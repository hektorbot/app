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
    var img = document.createElement('img');
    img.src = oeuvres.shift();
    elem.appendChild(img);
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
    }
    en_travail.etat = false;
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

function test () {
    console.log("lala");
}

