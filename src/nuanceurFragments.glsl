#version 410

uniform sampler2D leLutin;
uniform int texnumero;

in Attribs {
    vec4 couleur;
    vec2 texCoord;
} AttribsIn;

out vec4 FragColor;

void main( void )
{
     if( texnumero != 0){ //lorsque lutin est utilise
        vec4 texel = texture( leLutin, AttribsIn.texCoord );
        if ( texel.a < 0.1 ) discard;
        FragColor.rgb = mix( AttribsIn.couleur.rgb, texel.rgb, 0.6 );
        FragColor.a = AttribsIn.couleur.a;
    } else {
        FragColor = AttribsIn.couleur;
    }
}
