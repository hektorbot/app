$("#splash img").swipe(
    function(direction) {
        alert("ici");
        if(direction == "left") {
            document.location.href = previous_page;
        }
        if(direction == "right") {
            document.location.href = next_page;
        }
        console.log(direction);
    }, {
        preventDefault: false,
        mouse: true,
        pen: true,
        distance: 50

    }
);
