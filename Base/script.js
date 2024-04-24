// Background 
kaboom({
    background : [146,137,171],
    width : 800,
    height : 600
})

// Scène accueil
scene("Accueil", ()=>{
    // Background
    add([
        text("Press Spacebar to play !",{
           width : 400
        }),
        anchor("center"),
        pos(center())
     ]);
});
go("Accueil")

// Scène jeu 
scene("SceneJeu", ()=>{
    let SceneAccueil = document.createElement("div");
    SceneAccueil.setAttribute("id", "SceneAccueil");
    SceneAccueil.setAttribute("class", "SceneAccueil");
    document.body.appendChild(SceneAccueil);
})


// Status bar 

let BarStatut = document.createElement("div");
BarStatut.setAttribute("id", "BarStatut");
BarStatut.setAttribute("class", "BarStatut");
document.body.appendChild(BarStatut);