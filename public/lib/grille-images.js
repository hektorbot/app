function add_images (n) {

    if (n >= oeuvres.length) {
        chargement_termine = true;
        n = oeuvres.length;
    }

    var elems = [];
    var fragment = document.createDocumentFragment();
    for ( var i = 0; i < n; i++  ) {
        var elem = getItemElement();
        fragment.appendChild( elem  );
        elems.push(elem);
    }

    grid.appendChild(fragment);
    msnry.appended(elems);

    setTimeout(function () {
        msnry.layout();
        resize_grid();
    }, 1000);
}

function getItemElement() {
    var elem = document.createElement('div');
    var a = document.createElement('a');
    var img = document.createElement('img');
    var oeuvre = oeuvres.shift();
    img.src = oeuvre.thumbnail;
    a.href = "/paysages/" + oeuvre.slug;
    a.appendChild(img);
    elem.appendChild(a);
    elem.className = 'grid-item';
    return elem;
}

function ajouter_images () {

    window.removeEventListener('scroll', ajouter_images);

    if(chargement_termine) { return; }

    // Si ont est a + de 75% de la page
    if(get_height_ecran() > 0.75 * window.scrollY){ add_images(images_at_scroll); }

    window.addEventListener('scroll', ajouter_images);
}

function resize_grid() {
    var section = document.getElementById("oeuvres");
    var images = section.querySelectorAll(".grid-item");
    var derniere_image = images[images.length-1];

    section.style.height = (100 + derniere_image.querySelector("img").height + get_height(derniere_image)) + "px";
}

function get_height(elem) {
    return parseInt(elem.style.top.substr(0, elem.style.top.length-2));
}

function get_height_ecran (){
    return Math.max( document.body.scrollHeight, document.body.offsetHeight);
}

function redraw () {
    var style = document.getElementById("style-colonnes-grille");
    var section = document.getElementById("oeuvres");

    style.innerHTML = ".grid-item {width: " + (section.offsetWidth - ((nombre_colonnes - 1) * gutter)) / nombre_colonnes + "px;}";

    msnry.layout();
    resize_grid();
}

window.onload = function () {
    var section = document.getElementById("oeuvres");

    var style = document.createElement("style");
    style.id = "style-colonnes-grille";
    style.innerHTML = ".grid-item {width: " + (section.offsetWidth - ((nombre_colonnes - 1) * gutter)) / nombre_colonnes + "px;}";
    document.body.appendChild(style);

    grid = document.querySelector('.grid');
    msnry = new Masonry( grid, {
        fitWidth: true,
        gutter: gutter
    });

    add_images(images_at_loading);
    section.style.minHeight = (get_height_ecran() + 100) + "px";

    window.addEventListener('scroll', ajouter_images);
    window.addEventListener('resize', redraw);
};
