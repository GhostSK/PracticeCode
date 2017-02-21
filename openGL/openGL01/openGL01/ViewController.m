//
//  ViewController.m
//  openGL01
//
//  Created by 胡杨林 on 16/12/12.
//  Copyright © 2016年 胡杨林. All rights reserved.
// 参考教程链接
//http://mississi.blog.163.com/blog/#m=0&t=1&c=fks_084070086082087070086081087095085086083071092095084067085


#import "ViewController.h"
/*
 
 在你开始之前  target->Build Phases中 Link Binary With Libraries里添加三个框架
 QuartzCore.framework
 OpenGLES.framework
 GLKit.framework
 然后把VC的.h文件里，添加 #import <GLKit/GLKit.h> 并将继承修改为了GLKViewController
 ----重要-----
 storyBoard中把对应VC中的view关联类改为GLKView不然会崩溃
 
 
 */

GLfloat squareVertexData[48] = { //注意，是GLfloat，不是CGFloat
     0.5,0.5,-0.9,    0.0,0.0,1.0,    1.0,1.0,
    -0.5,0.5,-0.9,    0.0,0.0,1.0,    0.0,1.0,
     0.5,-0.5,-0.9,   0.0,0.0,1.0,    1.0,0.0,
     0.5,-0.5,-0.9,   0.0,0.0,1.0,    1.0,0.0,
    -0.5,0.5,-0.9,    0.0,0.0,1.0,    0.0,1.0,
    -0.5,-0.5,-0.9,   0.0,0.0,1.0,    0.0,0.0
};
/*
每行顶点数据的排列含义是：

顶点X、顶点Y，顶点Z、法线X、法线Y、法线Z、纹理S、纹理T。

在后面解析此数组时，将参考此规则。
*/
@interface ViewController ()

@property(strong,nonatomic)EAGLContext *context;
@property(strong,nonatomic)GLKBaseEffect *effect;
@property(assign,nonatomic)GLuint program;
@property(assign,nonatomic)CGFloat rotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
//    [EAGLContext setCurrentContext:self.context];
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:_context];
    glEnable(GL_DEPTH_TEST);
    
    self.effect = [[GLKBaseEffect alloc]init];
    self.effect.light0.enabled = GL_TRUE;
//    self.effect.light0.diffuseColor = GLKVector4Make(0.0, 1.0, 0.0, 1.0);  //渲染效果光照，就是这里造成了后面的绿色
    self.effect.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);  //上一句换成这一句改为自然光，色泽正常
    /*
     第一部分：使用“ES2”创建一个“EAGLContext”实例。
     
     第二部分：将“view”的context设置为这个“EAGLContext”实例的引用。并且设置颜色格式和深度格式。
     
     第三部分：将此“EAGLContext”实例设置为OpenGL的“当前激活”的“Context”。这样，以后所有“GL”的指令均作用在这个“Context”上。随后，发送第一个“GL”指令：激活“深度检测”。
     
     第四部分：创建一个GLK内置的“着色效果”，并给它提供一个光源，光的颜色为绿色。
     */
    
    //Vertex Data
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    /*
     这几行代码表示的含义是：声明一个缓冲区的标识（GLuint类型）
     让OpenGL自动分配一个缓冲区并且返回这个标识的值à绑定这个缓冲区到当前“Context”à最后，
     将我们前面预先定义的顶点数据“squareVertexData”复制进这个缓冲区中。
     注：参数“GL_STATIC_DRAW”，它表示此缓冲区内容只能被修改一次，但可以无限次读取。
     */
    //将缓冲区的数据复制进通用定点属性中
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 4 * 8, (char *)NULL + 0);;
    /*
     首先激活顶点属性（默认关闭） GLKVertexAttribPosition是顶点属性集中“position”属性的索引
     顶点属性集中包含五种属性  位置  法线  颜色 纹理0  纹理1
     索引值分别是0-4
     激活以后，使用glVertexAttribPointer方法来填充数据
     参数含义分别为  顶点属性索引（这里是位置） 三个分量的矢量  类型是浮点 填充时不需要单位化（GL_FALSE）数据中每行的跨度是32个字节（4字节*8浮点 参见位置数组）
     最后一个参数是偏移量的指针 用来确定第一个数据将从内存数据块的什么地方开始
     */
    
    //继续复制其他数据——注意要先激活属性再复制
    glEnableVertexAttribArray(GLKVertexAttribNormal); //法线
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 4* 8, (char *)NULL + 12);
    /*
     关于法线
     一般约定为“顶点以逆时针次序出现在屏幕上的面”为“正面”。
     
     世界坐标是OpenGL中用来描述场景的坐标，Z+轴垂直屏幕向外，X+从左到右，Y+轴从下到上，是右手笛卡尔坐标系统。我们用这个坐标系来描述物体及光源的位置。
     */
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);//纹理0
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4*8, (char * )NULL + 24);
    //属性填充完以后，可以显示内容了。
    //在GLKit框架中，尽管OpenGL的行为是有GLKVC和GLKView联合控制的，但是实际上GLKView中不需要写任何代码，因为
    //GLKView类在每一帧中触发的两个方法update和glkView都转交给GLKVC代理执行了。
    //在VC.m中添加两个方法 -(void)update -(void)glkView(GLKView *)view drawInRect:(CGRect)rect
    
    //lesson7 添加纹理
    //预先准备一张正方形的图片素材，导入工程。
    //使用GLKTextureLoader加载纹理
    //在viewdidLoad中追加如下代码
    //texture
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"444.jpeg" ofType:nil];
    //针对图像颠倒的相关   GLKit加载纹理默认坐标设置在左上角，但是OpenGL的纹理贴图坐标却是在左下角
    //在加载纹理之前添加一个options
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil];
    
//    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:nil];
    //把上一句换成下面的一句就可以翻转纹理图片
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.name = textureInfo.name;
    /*
     首先用“NSBundle”找到资源“Tulips.jpg”的路径，然后用“GLKTextureLoader”类方法同步加载这个纹理，也可以用它的实例方法异步进行加载。
     
     默认，此图片加载进TEXTURE0，如果需要加载进其他单元，需要先用指令“glActiveTexure(GL_TEXTUREn)”。——n为1-（CL_COMBINED_TEXTURE_IMAGE_UNITS-1）中的一个数值。
     
     加载成功后，该纹理的信息都保存在“textureInfo”中，以后，直接使用此变量的相关属性，就可以在OpenGL中应用这个纹理了。
     */
    //这里显示一张上下颠倒，被绿色灯光渲染的素材图片  如果调整了viewdidload最开始的初始化部分代码，会显示正常的图片
    
    //使用自定义的着色器
    //迄今，只是简单地调用了GLKit内置的着色程序进行渲染，某些情况下，可能需要使用自己的特殊的着色器
    //一个着色器有两个部分构成，（可能是两个文件也可以是两个硬编码嵌在程序中的代码段）
    //他们分别是顶点着色程序和片段着色程序
    //创建两个empty文件，分别命名为v.shader 和  f.shader （shader着色器）
    //代码见两个文件
    //在OpenGL中使用自定义着色器过程比较繁琐，需要
    //家在这个文件-->转化为GLChar（UTF8编码）-->保存进GPU内存-->编译内存中的代码-->附着给program对象-->将program连接到当前context，这样才能在OpenGL中发挥作用
    //加载自定义着色器的方法提取成两个自定义方法在下方
    //使用自定义着色器的方法如下
    NSString *vertFile = [[NSBundle mainBundle]pathForResource:@"v.shader" ofType:nil];
    NSString *fragFile = [[NSBundle mainBundle]pathForResource:@"f.shader" ofType:nil];
    _program = [self loadShaders:vertFile frag:fragFile];
    int params;
    glGetProgramiv(_program, GL_LINK_STATUS, &params);
    //如果返回的params为1，则说明一切正常
    if (params != 1) {
        NSLog(@"自定义着色器发挥失误，boom~");
    }
    //为着色器提供参数
    //顶点着色程序需要一个属性参数  position （表示顶点的位置）
//    需要在glkView方法中添加
//    glUseProgram(_program);
//    glDrawArrays(GL_TRIANGLES, 0, 6);
//    这样两行代码
//    现在应该有一个红色的矩形覆盖在你的素材图片上方，这就是自定义着色器渲染的
    
    //下面第一句是绑定position属性到通用顶点属性索引0上，
    //第二句是绑定texCoord到通用顶点属性索引3上 PS1是法线2是顶点颜色
    //注意，这里_program在第一个正方形中已经绑定过了导入的素材纹理，所以可以直接拿来用
    glBindAttribLocation(_program, 0, "position");
    glBindAttribLocation(_program, 3, "texCoord");
    //只有在使用glLinkProgram方法调用后，绑定才能生效
    glLinkProgram(_program);
//    第二部分，绑定统一的纹理sample2D变量到纹理0号单元前（注意！是之前！）要先调用
    //gluseprogram方法才能起作用
    glUseProgram(_program);
    
    GLint colorMap = glGetUniformLocation(_program, "colorMap");
    //将纹理绑定到_program
    glUniform1i(colorMap, 0);
    //在使用GLKTextureLoader加载纹理时，默认激活的是0号单元，如果激活的是其他单元，上一句0响应改为对应序号
    
    //在上述着色器代码中，是直接使用 gl_Position = position;
    //也就是说顶点位置没有经过任何变换直接使用了她的原始数据 所以图像被显示成一个矩形
    //下面引入变换矩阵
    //修改顶点着色器代码 ——在两个着色器文件还有update方法代码中
    
    
    //最后，动画效果，就是有规律的在update方法中修改一些Matrix参数，连续刷新时，就产生了动画的感觉
    //代码添加在update中
    
    
}

//第一次循环中县调用glkView在调用update
//一般讲场景数据变化放在update中，而渲染代码放在glkView中

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    //在渲染前先进行清除，清除颜色缓冲区和深度缓冲区中的内容，并填充淡蓝色背景 （默认是黑色）
    glClearColor(0.3, 0.6, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    //prepareToDraw方法是让效果effect针对当前context的状态进行一些配置，始终把GL_TEXTURE_PROGRAM状态定位到effect对象的着色器上
//    此外如果effect使用了纹理，他也会修改GL_TEXTURE_BINDING_2D;
    glDrawArrays(GL_TRIANGLES, 0, 6);
//    然后用glDrawArrays方法让OpenGL画出两个三角形，拼合为一个正方形，OpenGL会自动从通用顶点属性中取出这些数据，组装，再用effect渲染
    
    //下面为使用自定义着色器时需要添加的顶点信息
    glUseProgram(_program);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
}
-(void)update{
    // 由于effect的投影矩阵是一个单位矩阵，不做任何变换，将场景（-1，-1，-1）到（1，1，1）的立方体范围的物体，
    //    投射到屏幕的（-1，-1）到（1，1）的范围上，因此当屏幕不是正方形的时候，图案会被拉伸成矩形
    //    透视投影的观察点位于原点（0，0，0）并沿Z轴负向前进
    
    //    CGSize size = self.view.bounds.size;
    //    float aspect = fabs(size.width/size.height);
    //    GLKMatrix4 projectionMatrix = GLKMatrix4Identity;
    //    projectionMatrix = GLKMatrix4Scale(projectionMatrix, 1.0f, aspect, 1.0);
    //    self.effect.transform.projectionMatrix = projectionMatrix;
    
    //上面注释掉的方法用于简单地计算屏幕纵横比例，然后缩放单位矩阵的Y轴，强制将Y轴单位刻度与X轴保持一致
    
    //上述本质上仍然是一个正交投影，要模拟人眼观察的效果，必须要使用透视投影，即下文
    
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width/size.height);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 10.0);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    //这个时候由于透视体与透视视点太近，所以左右无法显示完整
    //有两个方法解决这个问题，一个是修改原始的顶点数据（Z轴值）使之更远一点
    //另一种是通过所谓的模型视图矩阵，将正方形变换到远一点的位置
    //第二种方法的代码如下；
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, -1.0);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    //至此，显示出一个精确的正方形
    
    
    
    //对自定义着色器追加矩阵变换的代码相关
    
    GLint mat = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    //添加下一句可以使自定义着色器的渲染进行偏离
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 1.0, 1.0, -1.0);
    /*
     OpenGL的矩阵变换是放在一个矩阵堆栈中的（后进先出），代码中矩阵变换的次序，决定了堆栈中矩阵的变换顺序。所以，上述矩阵的变换实际上是倒过来进行的：先做平移，再做旋转，这样它就围绕屏幕中心旋转了。
     
     把上面的代码中“平移”和“旋转”交换一下次序即可：
     */
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 0.0, 0.0, 1.0);//旋转动画
    //只要让_rotation每一帧旋转一点，并以此修改modelViewMatrix矩阵
    
    
    
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    glUniformMatrix4fv(mat, 1, GL_FALSE, modelViewProjectionMatrix.m);
    //查询到modelViewProjectionMatrix变量计算合并矩阵 并传给着色器
    
    //至此，显示两个完全重合的正方形
    
    _rotation +=  0.5;  //修改rotation

    
    
    
}
#pragma mark -自定义着色器方法两个
-(GLint)loadShaders:(NSString *)vert frag:(NSString *)frag{
    GLuint vertShader,fragShader;
    GLint program = glCreateProgram();
    [self compileShader:&vertShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];
    
    glAttachShader(program, vertShader);
    glAttachShader(program, fragShader);
    
    glLinkProgram(program);
    return program;
}

-(void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file{
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    const GLchar *source = (GLchar *)[content UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
