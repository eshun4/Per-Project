var toggleButton = document.querySelector('.toggle-button');
var mobileNav = document.querySelector('.mobile-nav');
var backdrop = document.querySelector(".backdrop");


function closeModal() {
    backdrop.style.display = "none";
}

backdrop.addEventListener("click", function() {
    mobileNav.style.display = 'none';
    closeModal();
});

toggleButton.addEventListener('click', function() {
    mobileNav.style.display = 'block';
    backdrop.style.display = 'block';
});