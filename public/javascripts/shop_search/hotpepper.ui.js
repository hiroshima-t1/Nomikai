/*
 * hotpepper.ui.js - UI library for HotPepper Web Service
 * AUTHOR: Toshimasa Ishibashi iandeth [at] gmail.com
 * VERSION: 1.00
 */

// everything wrapped in jQuery -
// same effect as jQuery.noConflict() for use with prototype.js
(function($){

if( typeof( HotPepper ) != 'function' ) {
    HotPepper = function (){};
}
if( typeof( HotPepper.UI ) != 'function' ) {
    HotPepper.UI = function (){};
}

/*
 * HotPepper.UI.Places.Pulldown - エリア選択 プルダウン
 * VERSION 1.01
 * CHANGES
 *   2008-03-26 v1.01 Recruit.UI.Base.Hierarchy 利用に変更
 *   2008-01-21 v1.00 released
 */
if( typeof( HotPepper.UI.Places ) != 'function' ) {
    HotPepper.UI.Places = function (){};
}
/*
 * HotPepper.UI.Places
 */
// replace large area code to service area code
HotPepper.UI.Places.replace_la_to_sa_code =
function ( obj ){
    var sa = obj.large_area;
    sa.code = sa.code.replace( /^\w{2}/, 'SA' );
    obj.service_area = sa;
    delete obj.large_area;
    return obj;
};
// replace service area code to large area code
HotPepper.UI.Places.replace_sa_to_la_code =
function ( obj ){
    var la = obj.service_area;
    la.code = la.code.replace( /^\w{2}/, 'Z0' );
    obj.large_area = la;
    delete obj.service_area;
    return obj;
};
/*
 * HotPepper.UI.Places.Pulldown
 */
HotPepper.UI.Places.Pulldown =
Class.create( Recruit.UI.Base.Hierarchy, {
    _get_definition : function (){
        var ret = [
            { cls:  HotPepper.UI.Places.LargeServiceArea.Pulldown },
            { cls:  HotPepper.UI.Places.ServiceArea.Pulldown      },
            { cls:  HotPepper.UI.Places.MiddleArea.Pulldown       },
            { cls:  HotPepper.UI.Places.SmallArea.Pulldown        }
        ];
        return ret;
    }
});

/*
 * HotPepper.UI.Places.LargeServiceArea.Pulldown
 */
if( typeof( HotPepper.UI.Places.LargeServiceArea ) != 'function' ) {
    HotPepper.UI.Places.LargeServiceArea = function (){};
}
HotPepper.UI.Places.LargeServiceArea.Pulldown =
Class.create( Recruit.UI.Base.Pulldown.JSONP, {
    _get_def_props: function (){
        return {
            id         : 'hpp-large-service-area-sel',
            name       : 'large_service_area',
            label      : '大サービスエリア',
            has_parent : false
        };
    },
    _get_driver: function (){
        return new Recruit.UI.Driver.JSONP({
            url : '/hotpepper/large_service_area/v1/'
        });
    },
    _get_selections_material: function (){
        return this.driver.results.large_service_area;
    }
});

/*
 * HotPepper.UI.Places.ServiceArea.Pulldown
 */
if( typeof( HotPepper.UI.Places.ServiceArea ) != 'function' ) {
    HotPepper.UI.Places.ServiceArea = function (){};
}
HotPepper.UI.Places.ServiceArea.Pulldown =
Class.create( Recruit.UI.Base.Pulldown.JSONP, {
    _get_def_props: function (){
        return {
            id         : 'hpp-service-area-sel',
            name       : 'service_area',
            label      : 'サービスエリア',
            has_parent : true,
            parent     : 'large_service_area',
            large_service_area : ''
        };
    },
    _get_driver: function (){
        return new Recruit.UI.Driver.JSONP({
            url : '/hotpepper/service_area/v1/'
        });
    },
    _get_selections_material: function (){
        var arr = [];
        var _self = this;
        $.each( this.driver.results.service_area, function (){
            if( this.large_service_area.code == _self.large_service_area ){
                arr.push( this );
            }
        });
        return arr;
    }
});

/*
 * ABROAD.UI.Places.Middle.Pulldown
 */
if( typeof( HotPepper.UI.Places.MiddleArea ) != 'function' ) {
    HotPepper.UI.Places.MiddleArea = function (){};
}
HotPepper.UI.Places.MiddleArea.Pulldown =
Class.create( Recruit.UI.Base.Pulldown.JSONP, {
    _get_def_props: function (){
        return {
            id         : 'hpp-middle-area-sel',
            name       : 'middle_area',
            label      : '中エリア',
            has_parent : true,
            parent     : 'service_area',
            service_area : ''
        };
    },
    _fix_params: function ( prm ){
        // translate service_area to large_area
        if( prm.service_area ){
            var obj = {
                service_area: { code: prm.service_area }
            };
            obj = HotPepper.UI.Places.replace_sa_to_la_code( obj );
            prm.large_area = obj.large_area.code;
            delete prm.service_area;
        }
        return prm;
    },
    _get_driver: function (){
        return new Recruit.UI.Driver.JSONP({
            url : '/hotpepper/middle_area/v1/'
        });
    },
    _get_selections_material: function (){
        return this.driver.results.middle_area;
    }
});

/*
 * ABROAD.UI.Places.SmallArea.Pulldown
 */
if( typeof( HotPepper.UI.Places.SmallArea ) != 'function' ) {
    HotPepper.UI.Places.SmallArea = function (){};
}
HotPepper.UI.Places.SmallArea.Pulldown =
Class.create( Recruit.UI.Base.Pulldown.JSONP, {
    _get_def_props: function (){
        return {
            id          : 'hpp-small-area-sel',
            name        : 'small_area',
            label       : '小エリア',
            has_parent  : true,
            parent      : 'middle_area',
            middle_area : ''
        };
    },
    _get_driver: function (){
        return new Recruit.UI.Driver.JSONP({
            url : '/hotpepper/small_area/v1/'
        });
    },
    _get_selections_material: function (){
        return this.driver.results.small_area;
    }
});


/*
 * HotPepper.UI.Order.Pulldown - 並び順プルダウン
 * VERSION 1.00
 * CHANGES
 *   2008-01-22 v1.00 released
 */
if( typeof( HotPepper.UI.Order ) != 'function' ) {
    HotPepper.UI.Order = function (){};
}
HotPepper.UI.Order.Pulldown =
Class.create( Recruit.UI.Base.Pulldown, {
    _get_def_props: function (){
        return {
            id             : 'hpp-order-sel',
            name           : 'order',
            label          : '並び順',
            first_opt_text : 'オススメ順'
        };
    },
    get_selections: function (){
        return {
            "1": "店名かな順",
            "2": "ジャンル順",
            "3": "小エリア順"
        };
    }
});

/*
 * HotPepper.UI.Budget.Pulldown - 予算プルダウン
 * VERSION 1.00
 * CHANGES
 *   2008-01-22 v1.00 released
 */
if( typeof( HotPepper.UI.Budget ) != 'function' ) {
    HotPepper.UI.Budget = function (){};
}
HotPepper.UI.Budget.Pulldown =
Class.create( Recruit.UI.Base.Pulldown.JSONP, {
    _get_def_props: function (){
        return {
            id          : 'hpp-budget-sel',
            name        : 'budget',
            label       : '予算'
        };
    },
    _get_driver: function (){
        return new Recruit.UI.Driver.JSONP({
            url : '/hotpepper/budget/v1/'
        });
    },
    _get_selections_material: function (){
        return this.driver.results.budget;
    }
});

/*
 * HotPepper.UI.Genre.Pulldown - ジャンルプルダウン
 * VERSION 1.00
 * CHANGES
 *   2008-01-26 v1.00 released
 */
if( typeof( HotPepper.UI.Genre ) != 'function' ) {
    HotPepper.UI.Genre = function (){};
}
HotPepper.UI.Genre.Pulldown =
Class.create( Recruit.UI.Base.Pulldown.JSONP, {
    _get_def_props: function (){
        return {
            id          : 'hpp-genre-sel',
            name        : 'genre',
            label       : 'ジャンル'
        };
    },
    _get_driver: function (){
        return new Recruit.UI.Driver.JSONP({
            url : '/hotpepper/genre/v1/'
        });
    },
    _get_selections_material: function (){
        return this.driver.results.genre;
    }
});

/*
 * HotPepper.UI.Food.Pulldown - 料理プルダウン
 * VERSION 1.00
 * CHANGES
 *   2008-01-26 v1.00 released
 */
if( typeof( HotPepper.UI.Food ) != 'function' ) {
    HotPepper.UI.Food = function (){};
}
HotPepper.UI.Food.Pulldown =
Class.create( Recruit.UI.Base.Pulldown.JSONP, {
    _get_def_props: function (){
        return {
            id          : 'hpp-food-sel',
            name        : 'food',
            label       : '料理'
        };
    },
    _get_driver: function (){
        return new Recruit.UI.Driver.JSONP({
            url : '/hotpepper/food/v1/'
        });
    },
    _get_selections_material: function (){
        return this.driver.results.food;
    }
});

/*
 * HotPepper.UI.PartyCapacity.Pulldown - 宴会収容人数プルダウン
 * VERSION 1.00
 * CHANGES
 *   2008-01-31 v1.00 released
 */
if( typeof( HotPepper.UI.PartyCapacity ) != 'function' ) {
    HotPepper.UI.PartyCapacity = function (){};
}
HotPepper.UI.PartyCapacity.Pulldown =
Class.create( Recruit.UI.Base.Pulldown, {
    _get_def_props: function (){
        return {
            id          : 'hpp-party-capacity-sel',
            name        : 'party_capacity',
            label       : '宴会収容人数'
        };
    },
    get_selections: function (){
        return {
            "10"  : "10人以上",
            "20"  : "20人以上",
            "30"  : "30人以上",
            "40"  : "40人以上",
            "50"  : "50人以上",
            "75"  : "75人以上",
            "100" : "100人以上",
            "150" : "150人以上",
            "200" : "200人以上",
            "300" : "300人以上"
        };
    }
});

/*
 * HotPepper.UI.Kodawari.Checkbox - こだわり選択チェック
 * VERSION 1.00
 * CHANGES
 *   2008-02-11 v1.00 released
 */
if( typeof( HotPepper.UI.Kodawari ) != 'function' ) {
    HotPepper.UI.Kodawari = function (){};
}
HotPepper.UI.Kodawari.Checkbox =
Class.create( Recruit.UI.Base.Checkbox, {
    _get_def_props: function (){
        return {
            id          : 'hpp-kodawari-checkbox',
            label       : 'こだわり',
            template    : 'table_3c'
        };
    },
    get_selections: function (){
        return [
            { value:'1', name:'wedding',       label: 'ウェディング二次会等' },
            { value:'1', name:'course',        label: 'コースあり' },
            { value:'1', name:'free_drink',    label: '飲み放題' },
            { value:'1', name:'free_food',     label: '食べ放題' },
            { value:'1', name:'private_room',  label: '個室あり' },
            { value:'1', name:'horigotatsu',   label: '掘りごたつあり' },
            { value:'1', name:'tatami',        label: '座敷あり' },
            { value:'1', name:'cocktail',      label: 'カクテル充実' },
            { value:'1', name:'shochu',        label: '焼酎充実' },
            { value:'1', name:'sake',          label: '日本酒充実' },
            { value:'1', name:'wine',          label: 'ワイン充実' },
            { value:'1', name:'card',          label: 'カード可' },
            { value:'1', name:'non_smoking',   label: '禁煙席' },
            { value:'1', name:'charter',       label: '貸切' },
            { value:'1', name:'ktai',          label: '携帯電話OK' },
            { value:'1', name:'parking',       label: '駐車場あり' },
            { value:'1', name:'barrier_free',  label: 'バリアフリー' },
            { value:'1', name:'sommelier',     label: 'ソムリエがいる' },
            { value:'1', name:'night_view',    label: '夜景がキレイ' },
            { value:'1', name:'open_air',      label: 'オープンエア' },
            { value:'1', name:'show',          label: 'ライブ・ショーあり' },
            { value:'1', name:'equipment',     label: 'エンタメ設備' },
            { value:'1', name:'karaoke',       label: 'カラオケあり' },
            { value:'1', name:'band',          label: 'バンド演奏可' },
            { value:'1', name:'tv',            label: 'TV・プロジェクター' },
            { value:'1', name:'lunch',         label: 'ランチあり' },
            { value:'1', name:'midnight',      label: '23時以降も営業' },
            { value:'1', name:'midnight_meal', label: '23時以降食事OK' },
            { value:'1', name:'english',       label: '英語メニューあり' },
            { value:'1', name:'pet',           label: 'ペット可' },
            { value:'1', name:'child',         label: 'お子様連れOK' }
        ];
    }
});

// end of jQuery no-conflict wrapper
})(jQuery);
