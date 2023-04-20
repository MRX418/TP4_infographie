#version 410

layout(points) in;
layout(points, max_vertices = 1) out;

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
    //float sens; // du vol (partie 3)
    //float hauteur; // de la particule dans le repère du monde (partie 3)
} AttribsIn[];

out Attribs {
    vec4 couleur;
} AttribsOut;

// la hauteur minimale en-dessous de laquelle les lutins ne tournent plus (partie 3)
const float hauteurInerte = 8.0;

void main()
{
    // assigner la position du point
    gl_Position = matrProj * gl_in[0].gl_Position;

    // assigner la taille des points (en pixels)
    gl_PointSize = gl_in[0].gl_PointSize;

    // assigner la couleur courante
    AttribsOut.couleur = AttribsIn[0].couleur;

    EmitVertex();
}
