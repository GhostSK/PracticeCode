//v.shader

attribute vec4 position;
attribute vec2 texCoord;  //使用自定义纹理新增

varying lowp vec2 coord;  //使用自定义纹理新增

uniform mat4 modelViewProjectionMatrix;  //使用变换矩阵新增

//原本着色器直接使用gl_Position = position,不经过任何变换
//直接使用它的原始数据，所以图像也被显示为一个矩形

void main()
{
    coord = texCoord;  //使用自定义纹理新增
    //gl_Position = position;
    gl_Position = modelViewProjectionMatrix * position;
    //添加了统一的矩阵变量 modelViewProjectionMatrix （模型 视图 投影矩阵，是这三个变换矩阵乘法合并后得到的单个矩阵）
}
