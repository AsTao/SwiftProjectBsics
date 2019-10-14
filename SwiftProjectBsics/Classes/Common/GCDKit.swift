//
//  GCDKit.swift
//  Alamofire
//
//  Created by tao on 2019/9/29.
//

import UIKit

public class GCDKit  {
    private var mainQueue :DispatchQueue{
         return DispatchQueue.main
     }
    private var globalQueue :DispatchQueue{
        return DispatchQueue.global()
    }
    
    /// 主线程需要子线程的处理结果
    public func handle<T>(somethingLong: @escaping () -> T, finshed: @escaping (T) -> ()) {
        globalQueue.async {
            let data = somethingLong()
            self.mainQueue.async {
                finshed(data)
            }
        }
    }
    /// 主线程不需要子线程的处理结果
    public func handle(somethingLong: @escaping () -> (), finshed: @escaping () -> ()) {
        let workItem = DispatchWorkItem {
            somethingLong()
        }
        globalQueue.async(execute: workItem)
        workItem.wait()
        finshed()
    }
    
    public typealias GCDKitHandleBlock = () -> ()
    
    private var handleBlockArr :[GCDKitHandleBlock] = []
    
    /// 向全局并发队列添加任务，添加的任务会同步执行
    public func wait(code: @escaping GCDKitHandleBlock) -> GCDKit {
        handleBlockArr.append(code)
        return self
    }

    /// 处理完毕的回调，在主线程异步执行
    public func finshed(code: @escaping GCDKitHandleBlock) {
        globalQueue.async {
            for workItem in self.handleBlockArr {
                workItem()
            }
            self.handleBlockArr.removeAll()
            self.mainQueue.async {
                code()
            }
        }
    }

    private let group = DispatchGroup()
    
    /// 向自定义并发队列添加任务，添加的任务会并发执行
    public func handle(code: @escaping GCDKitHandleBlock) -> GCDKit {
        let queue = DispatchQueue(label: "", attributes: .concurrent)
        let workItem = DispatchWorkItem {
            code()
        }
        queue.async(group: group, execute: workItem)
        return self
    }

    /// 此任务执行时会排斥其他的并发任务，一般用于写入事务，保证线程安全。
    public func barrierHandle(code: @escaping GCDKitHandleBlock) -> GCDKit {
        let queue = DispatchQueue(label: "", attributes: .concurrent)
        let workItem = DispatchWorkItem(flags: .barrier) {
            code()
        }
        queue.async(group: group, execute: workItem)
        return self
    }

    /// 处理完毕的回调，在主线程异步执行
    public func allDone(code: @escaping GCDKitHandleBlock) {
        group.notify(queue: .main, execute: {
            code()
        })
    }
    /// 延时一段时间后执行代码
    public func run(when: DispatchTime, code: @escaping GCDKitHandleBlock) {
        DispatchQueue.main.asyncAfter(deadline: when) {
            code()
        }
    }

    ///并发循环
    public func map<T>(data: [T], code: (T) -> ()) {
        DispatchQueue.concurrentPerform(iterations: data.count) { (i) in
            code(data[i])
        }
    }
    ///并发循环
    public func run(code: (Int) -> (), repeting: Int) {
        DispatchQueue.concurrentPerform(iterations: repeting) { (i) in
            code(i)
        }
    }


}

extension GCDKit {
    /// 计时器
    ///
    /// - Parameters:
    ///   - start: 开始时间
    ///   - end: 结束时间
    ///   - repeating: 多久重复一次
    ///   - leeway: 允许误差
    ///   - eventHandle: 处理事件
    ///   - cancelHandle: 计时器结束事件
    func timer(start: DispatchTime,
               end: DispatchTime,
               repeating: Double,
               leeway: DispatchTimeInterval,
               eventHandle: @escaping GCDKitHandleBlock,
               cancelHandle: GCDKitHandleBlock? = nil)
    {
        let timer = DispatchSource.makeTimerSource()
        timer.setEventHandler {
            eventHandle()
        }
        timer.setCancelHandler {
            cancelHandle?()
        }
        timer.schedule(deadline: start, repeating: repeating, leeway: leeway)
        timer.resume()
        run(when: end) {
            timer.cancel()
        }
    }

}
