var toggleButton = document.querySelector('.toggle-button');
var mobileNav = document.querySelector('.mobile-nav');
var backdrop = document.querySelector(".backdrop");
var selectPlanButton = document.querySelector(".banner_contactMe__icon");
var modal = document.querySelector('.modal');
var closeButton = document.querySelector(".fa-close");


selectPlanButton.addEventListener('click', function(){
    modal.style.display ="block";
    backdrop.style.display ="block";
})

function closeModal() {
    backdrop.style.display = "none";
}

closeButton.addEventListener('click', function(){
    modal.style.display ="none";
    backdrop.style.display = "none";
    mobileNav.style.display = 'none';
})

// backdrop.addEventListener("click", function() {
    
// });

toggleButton.addEventListener('click', function() {
    mobileNav.style.display = 'block';
    backdrop.style.display = 'block';
});