#version 410

layout(points) in;
layout(triangle_strip, max_vertices = 4) out;

uniform mat4 matrProj;

uniform int texnumero;

layout (std140) uniform varsUnif
{
    float tempsDeVieMax;       // temps de vie maximal (en secondes)
    float temps;               // le temps courant dans la simulation (en secondes)
    float dt;                  // intervalle entre chaque affichage (en secondes)
    float gravite;             // gravité utilisée dans le calcul de la position de la particule
    float pointsize;           // taille des points (en pixels)
};

in Attribs {
    vec4 couleur;
    float tempsDeVieRestant;
    float sens; // du vol (partie 3)
    float hauteur; // de la particule dans le repère du monde (partie 3)
} AttribsIn[];

out Attribs {
    vec4 couleur;
    vec2 texCoord;
} AttribsOut;

// la hauteur minimale en-dessous de laquelle les lutins ne tournent plus (partie 3)
const float hauteurInerte = 8.0;

//reference: https://math.stackexchange.com/questions/2093314/rotation-matrix-of-rotation-around-a-point-other-than-the-origin
vec2 rotationCentre(vec2 coord, float angle) {
    float rotatedX = cos(angle) * coord.x - sin(angle) * coord.y;
    float rotatedY = sin(angle) * coord.x + cos(angle) * coord.y;
	return vec2(rotatedX, rotatedY);
}
void main()
{
    vec2 coins[4];
    coins[0] = vec2( -0.5,  0.5 );
    coins[1] = vec2( -0.5, -0.5 );
    coins[2] = vec2(  0.5,  0.5 );
    coins[3] = vec2(  0.5, -0.5 );

    // à partir du point, créer quatre points qui servent de coin aux deux triangles
    for ( int i = 0 ; i < 4 ; ++i )
    {
        // on positionne successivement aux quatre coins
        vec2 decalage = coins[i]; 

        AttribsOut.texCoord = coins[i] + vec2( 0.5, 0.5 ); // on utilise coins[] pour définir des coordonnées de texture

        // assigner la position du point
        gl_Position = matrProj * gl_in[0].gl_Position;

        // assigner la taille des points (en pixels)
        gl_PointSize = gl_in[0].gl_PointSize;

        float nlutins; // les positions dans la texture
        int num =0;

        // assigner la couleur courante
        AttribsOut.couleur = AttribsIn[0].couleur;
        switch (texnumero){
            case 1: 
                nlutins = 16.0; 
            break;
            case 3:
                nlutins = 12.0;  
            break;
            case 4:
                nlutins = 20.0; 
            break;
            case 2:
            case 5:  
                if(AttribsIn[0].hauteur >= hauteurInerte){
                    decalage = rotationCentre(coins[i], 6.0 * AttribsIn[0].tempsDeVieRestant);
                } 
            break;
        }

        if(texnumero !=2 && texnumero !=5){
            if(AttribsIn[0].hauteur >= hauteurInerte){
                    num = int ( mod ( 18.0 * AttribsIn[0].tempsDeVieRestant , nlutins ) );// 18 Hz
            }  
            AttribsOut.texCoord.s += num;
            AttribsOut.texCoord.s /= nlutins ;
            AttribsOut.texCoord.s *= AttribsIn[0].sens;
        }

        AttribsOut.couleur.a = clamp(AttribsIn[0].tempsDeVieRestant, 0  , 1);

        vec4 pos = vec4( gl_in[0].gl_Position.xy + gl_PointSize * decalage, gl_in[0].gl_Position.zw );
        gl_Position = matrProj * pos;    // on termine la transformation débutée dans le nuanceur de sommets

        EmitVertex();
    }
}
