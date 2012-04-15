//
//  Shader.vsh
//  AdMobileSamples
//
//  Created by Constantine Mureev on 2/18/11.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
    gl_Position.y += sin(translate) / 2.0;

    colorVarying = color;
}
