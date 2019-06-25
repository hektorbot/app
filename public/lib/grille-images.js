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
        elems.push( elem  );
    }
    // append elements to container
    grid.appendChild(fragment);
    // add and lay out newly appended elements
    msnry.appended(elems);
    msnry.reloadItems();
    msnry.layout();
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

    alert("scroll");
    if(en_travail.etat) return;

    if(chargement_termine) {
        window.removeEventListener('scroll', ajouter_images);
        return;
    }

    // Si ont est a + de 75% de la page
    if(Math.max( document.body.scrollHeight, document.body.offsetHeight ) > 0.75 * window.scrollY){
        en_travail.etat = true;
        add_images(10);
        resize_grid();
    }
    en_travail.etat = false;
}

function resize_grid() {
    var section = document.getElementById("oeuvres");
    var images = section.querySelectorAll(".grid-item");
    var derniere_image = images[images.length-1];

    section.style.height = derniere_image.querySelector("img").height + parseInt(derniere_image.style.top.substr(0, derniere_image.style.top.length-2)) + "px";
}

window.onload = function () {
    grid = document.querySelector('.grid');
    msnry = new Masonry( grid, {
        columnWidth: ".grid-sizer",
        gutter: ".gutter-sizer",
        itemSelector: '.grid-item'
        });

    add_images(10);

    window.addEventListener('scroll', ajouter_images);
};
