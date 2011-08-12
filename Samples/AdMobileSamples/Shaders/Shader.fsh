//
//  Shader.fsh
//  AdMobileSamples
//
//  Created by Constantine Mureev on 2/18/11.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
