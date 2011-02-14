// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/**
 * ツリー型メニュー (depends on prototype.js and tree.js)
 */ 
if (typeof Prototype == "object") {
  var treeMenu = Class.create({
    initialize : function () {
      if ($('tree_menu')) { this.loadTreeMenuState(); }
      this.addObservers();
    },

    addObservers : function () {
      if ($('tree_menu')) { 
        $('tree_menu').observe('click', this.saveTreeMenuState);
      }
    },

    /**
     * ツリーメニューの状態を保存
     */
    saveTreeMenuState : function (evt) {
      var el = evt.element(), state = "";

      if (el.tagName == "SPAN") {
        $$('#tree_menu li.children').each(function (li) {
          state += li.hasClassName("closed") ? 0 : 1;
        });
        document.cookie = encodeURIComponent("treeMenuState=" + state + ";");
      }
    },

    /**
     * ツリーメニューの状態をロード
     */                                 
    loadTreeMenuState : function () {
      var i = 0, state = [];
      document.cookie.split(";").each(function (item) {
        if (item.replace(/^\s+/g, "").startsWith("treeMenuState")) {
          state = decodeURIComponent(item).split("=")[1].gsub(/;.*$/, "").split("");
        }
      });
      initTree($('tree_menu'));
      $$('#tree_menu li.children').each(function (li) {
        if (state[i] == 0) { li.addClassName('closed'); }
        i += 1;
      });
    }
  });

  document.observe("dom:loaded", function () { new treeMenu(); });
}
