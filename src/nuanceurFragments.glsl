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
    // Mettre un test bidon afin que l'optimisation du compilateur n'élimine l'attribut "couleur".
    // Vous ENLEVEREZ cet énoncé inutile!
    // if ( AttribsIn.couleur.r + texnumero + texture(leLutin,vec2(0.0)).r < 0.0 ) discard;
     if( texnumero != 0){ //lorsque lutin est utilise
        //partie qui ne contient pas la texture devient transparente
        vec4 texel = texture( leLutin, AttribsIn.texCoord );
        if ( texel.a < 0.1 ) discard;
        FragColor.rgb = mix( AttribsIn.couleur.rgb, texel.rgb, 0.6 );
        FragColor.a = AttribsIn.couleur.a;
    } else {
        FragColor = AttribsIn.couleur;
    }
}
