document.getElementById('all-menu-btn').onclick = function() {
    document.getElementById('all-menu-overlay').style.display = 'block';
};
document.getElementById('close-all-menu').onclick = function() {
    document.getElementById('all-menu-overlay').style.display = 'none';
};
document.getElementById('all-menu-overlay').onclick = function(e) {
    if (e.target === this) this.style.display = 'none';
};
