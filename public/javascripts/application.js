// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var sidebarMenu;
document.observe("dom:loaded", function () {
    sidebarMenu = new SDMenu("menu");
    sidebarMenu.init();
    sidebarMenu.speed = 4;
    sidebarMenu.remember = true;
});

