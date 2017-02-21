//f.shader

varying lowp vec2 coord;  //使用自定义纹理新增

uniform sampler2D colorMap;  //使用自定义纹理新增

void main()
{
    //gl_fragColor = vec4(1,0,0,1);  //原本简单着红色，现在被注释
    gl_FragColor = texture2D(colorMap, coord.st);  //使用自定义纹理新增
}
