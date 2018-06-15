(function (e, t) {
    this[e] = t(),
    typeof define == "function" ? define(this[e]) : typeof module == "object" && (module.exports = this[e])
})("hryapp",
function (e) {
    var hryapp = {};
    var n = navigator.userAgent;
    var proSlice = Array.prototype.slice;
    var callBacks = {};
    var callBackIndex = 0;
    hryapp.iOS = /(iPad|iPhone|iPod).*?/.test(n);
    hryapp.android = /(Android).*?/.test(n);
    function buildFun(e, n) {
        var r = null,
        i = e.lastIndexOf("."),
        s = e.substring(0, i),
        o = e.substring(i + 1),
        u = g(s); //mapp.device 生成对应的数组存储关系
        if (u[o]) throw new Error("[mappapi]already has " + e);
        alert(hryapp.iOS + "；" + hryapp.android);
        n.iOS && hryapp.iOS ? r = n.iOS : n.android && hryapp.android ? r = n.android : n.browser && (r = n.browser),
        u[o] = r || S //存储函数
    }
    function S() { }
    function g(e) {
        var t = e.split("."),
        n = window;
        return t.forEach(function (e) {
            !n[e] && (n[e] = {}),
                n = n[e]
        }),
        n
    }
    function saveCallBackFun(args) {
        var lastArgument = Array.prototype.slice.call(args, args.length - 1);
        var callBack = lastArgument.length && lastArgument[lastArgument.length - 1];
        callBack && typeof callBack == "function" ? lastArgument.pop() : typeof callBack == "undefined" ? lastArgument.pop() : callBack = null;
        if (callBack == null) {
            return 0;
        }

        callBackIndex++;
        return callBack && (callBacks[callBackIndex] = callBack), callBackIndex;
    }
    function execCallBackFun(cIndex) {
        if (cIndex == 0) { return; }
        var backData = proSlice.call(arguments, 1);
        var i = typeof cIndex == "function" ? cIndex : callBacks[cIndex] || window[cIndex];

        backData = backData || [],
        typeof i == "function" ? proSlice ? setTimeout(function () {
            i.apply(null, backData)
        }, 0) : i.apply(null, backData) : console.log("mappapi: not found such callback: " + cIndex);
        delete callBacks[cIndex];
    }
    hryapp.build = buildFun;
    hryapp.saveCallBack = saveCallBackFun;
    hryapp.execCallBack = execCallBackFun;
    return hryapp;
}),
hryapp.build("hryapp.horoyhome.getUserInfo", {
    iOS: function (userId) {
//        alert("用户id:"+userId);
        i = hryapp.saveCallBack(arguments);
//        alert("模拟iOS原生调用，回调函数序号：" + i);
             window.webkit.messageHandlers.getUserInfo.postMessage({"callBackId": i,"userId": userId});
    },
    android: function (e) {
        alert("用户id:"+userId);
        i = hryapp.saveCallBack(arguments);
        alert("模拟android原生调用，回调函数序号：" + i);
    }
})

