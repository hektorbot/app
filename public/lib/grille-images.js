var grid = document.querySelector('.grid');
var msnry = new Masonry( grid, {
    fitWidth: true,
    columnWidth: 160,
    gutter: 10,
    itemSelector: '.grid-item'
});

window.setInterval(function () {

    // create new item elements
    var elems = [];
    var fragment = document.createDocumentFragment();
    for ( var i = 0; i < 3; i++  ) {
        var elem = getItemElement();
        fragment.appendChild( elem  );
        elems.push( elem  );
    }
    // append elements to container
    grid.appendChild( fragment  );
    // add and lay out newly appended elements
    msnry.appended( elems  );
    msnry.reloadItems();
    msnry.layout();
}, 1000);

function getItemElement() {
    var elem = document.createElement('div');
    var img = document.createElement('img');
    img.src = getimgname();
    elem.appendChild(img);
    elem.className = 'grid-item';
    return elem;
}

function getimgname () {
    var noms = [
        "http://3.bp.blogspot.com/-RIjj0rVkJ7g/Umz9fX7PwgI/AAAAAAAABfg/dzFIcFFgV0E/s1600/Wallpaper+1080p+Full+HD+Download.jpg",
        "http://www.wallpaperhdc.com/wp-content/uploads/2017/04/photography-wallpaper-full-hd-cool-photos.jpg",
        "http://getwallpapers.com/wallpaper/full/9/5/9/203235.jpg",
        "http://getwallpapers.com/wallpaper/full/9/5/9/203235.jpg",
        "https://wallpapershome.com/images/wallpapers/darts-1080x1920-4k-5k-wallpaper-hd-wheel-target-fire-water-561.jpg"
    ]
    var num = Math.round(Math.random()*100/25);
    return noms[num];
}

