
  
 1: HClassDocument\n
    在开发中对系统类或者第三方库，可以使用HClassDocument 对库文件进行分析\n
  使用:\n
    ->打印Class的所有属性
       +(void)scanProperty:(Class)clazz _super:(BOOL)hasSuper;
    ->打印Class所有实例方法
      +(void)scanInstanceMethod:(Class)clazz _super:(BOOL)hasSuper;
    ->当布局子视图后，发现布局不对 使用其  打印所有层级关系
      +(NSString *)scanSubView:(UIView *)_superView frame:(BOOL)frame;
      
  2: HClassExtension    
    runtime 对Class进行动态操作 (增加方法，属性，交换实现)
    -> 增加无附加参数的方法 无返回值
    -> 增加无附加参数的方法 有返回值
    -> 增加有一个附加参数的方法 无返回值
    -> 增加有一个附加参数的方法 有返回值
    -> 交换Class两个方法的实现 
    -> 为Class增加属性
      +(HInvocation *)classAddInstanceMethod:(Class)targetClazz  sel:(SEL)aSel blockImp:(void(^)(id _self,SEL __cmd))block;
      +(HInvocation *)classAddInstanceMethod:(Class)targetClazz  sel:(SEL)aSel impWithReturnResult:(id(^)(id _self,SEL __cmd))block;
      .....
  3：HInstanceProxy
     代理类，消息转发机制
     
