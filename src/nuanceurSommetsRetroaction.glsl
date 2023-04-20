#version 410

uniform vec3 bDim, posPuits;

layout (std140) uniform varsUnif
{
    float tempsDeVieMax;       // temps de vie maximal (en secondes)
    float temps;               // le temps courant dans la simulation (en secondes)
    float dt;                  // intervalle entre chaque affichage (en secondes)
    float gravite;             // gravité utilisée dans le calcul de la position de la particule
    float pointsize;           // taille des points (en pixels)
};

layout(location=6) in vec3 Vertex;
layout(location=7) in vec4 Color;
layout(location=8) in vec3 vitesse;
layout(location=9) in float tempsDeVieRestant;

out vec3 VertexMod;
out vec4 ColorMod;
out vec3 vitesseMod;
out float tempsDeVieRestantMod;

// Produire une valeur un peu aléatoire
uint seed = uint(temps * 1000.0) + uint(gl_VertexID);
uint randhash( ) // entre  0 et UINT_MAX
{
    uint i=((seed++)^12345391u)*2654435769u;
    i ^= (i<<6u)^(i>>26u); i *= 2654435769u; i += (i<<5u)^(i>>12u);
    return i;
}
float aleatoire( ) // entre  0 et 1
{
    const float UINT_MAX = 4294967295.0;
    return float(randhash()) / UINT_MAX;
}

void main( void )
{
    if ( tempsDeVieRestant <= 0.0 )
    {
        // couleur aléatoire par interpolation linéaire entre COULMIN et COULMAX
        const float COULMIN = 0.2; // valeur minimale d'une composante de couleur lorsque la particule (re)naît
        const float COULMAX = 0.9; // valeur maximale d'une composante de couleur lorsque la particule (re)naît

        // faire renaitre la particule au puits
        VertexMod = vec3(0.0); // à modifier

        // assigner un vitesse (pseudo) aléatoire
        vitesseMod = vec3( mix( -25.0, 25.0, aleatoire() ),   // entre -25 et 25
                           mix( -25.0, 25.0, aleatoire() ),   // entre -25 et 25
                           mix(  25.0, 50.0, aleatoire() ) ); // entre  25 et 50
        //vitesseMod = vec3( 0.0, 30.0, 50.0 );

        // nouveau temps de vie (pseudo) aléatoire
        tempsDeVieRestantMod = 0.0; // à modifier pour une valeur entre 0 et tempsDeVieMax secondes

        // couleur (pseudo) aléatoire par interpolation linéaire entre COULMIN et COULMAX
        ColorMod = vec4(0.0); // à modifier
    }
    else
    {
        // avancer la particule (méthode de Euler)
        VertexMod = Vertex; // modifier ...
        vitesseMod = vitesse;

        // diminuer son temps de vie
        tempsDeVieRestantMod = tempsDeVieRestant; // modifier ...

        // garder la couleur courante
        ColorMod = Color;

        // gérer la collision avec la demi-sphère
        // ...

        // gérer la ccollision avec le sol
        // hauteur minimale à laquelle une collision avec le plancher survient
        const float hauteurPlancher = 3.0;
        // ...

        // appliquer la gravité
        // ...
    }

    // Mettre un test bidon afin que l'optimisation du compilateur n'élimine pas les attributs dt, gravite, tempsDeVieMax posPuits et bDim.
    // Vous ENLEVEREZ cet énoncé inutile!
    if ( dt+bDim.x+gravite+tempsDeVieMax+posPuits.x < -100000 ) tempsDeVieRestantMod += .000001;
}
