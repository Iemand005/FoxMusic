void main()
{
//	gl_FrontColor = gl_Color;
	gl_FrontColor = vec4(255);
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = ftransform();
}
