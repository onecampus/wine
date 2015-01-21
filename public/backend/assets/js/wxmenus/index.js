$(document).ready(function() {
  /*
  添加一级菜单
  */
  $(".menu-add").click(function() {
    var menuName = $("#menu-name").val();
    if (menuName == "") {
      $(".menu-mesg").text("菜单名字不能为空");
      $(".menu-name-mesg").hide();
      $(".menu-mesg").show();
      return false;
    }
    var length = 0;
    for (var i = 0; i < menuName.length; i++) {
      var menuNameLength = menuName.charCodeAt(i);
      if (menuNameLength >= 0 && menuNameLength <= 128) {
        length += 1;
      } else {
        length += 2;
      }
    }
    if (length > 8) {
      $(".menu-mesg").text("超出字数范围");
      $(".menu-name-mesg").hide();
      $(".menu-mesg").show();
      return false;
    }
  });

  $("#menu-name").focus(function() {
    $(".menu-name-mesg").show();
    $(".menu-mesg").hide();
  });

  /*
  一级菜单增，删，改
  */

  /*
  增加二级菜单
  */
  $(".submenu-add").click(function() {
    var menuName = $("#submenu-name").val();
    if (menuName == "") {
      $(".submenu-mesg").text("菜单名字不能为空");
      $(".submenu-name-mesg").hide();
      $(".submenu-mesg").show();
      return false;
    }
    var length = 0;
    for (var i = 0; i < menuName.length; i++) {
      var menuNameLength = menuName.charCodeAt(i);
      if (menuNameLength >= 0 && menuNameLength <= 128) {
        length += 1;
      } else {
        length += 2;
      }
    }
    if (length > 16) {
      $(".submenu-mesg").text("超出字数范围");
      $(".submenu-name-mesg").hide();
      $(".submenu-mesg").show();
      return false;
    }
  });

  $("#submenu-name").focus(function() {
    $(".submenu-name-mesg").show();
    $(".submenu-mesg").hide();
  });

  /*
  删除一级菜单
  */
  $(".menu-edit-del").click(function() {});

  /*
  二级菜单编辑
  */
  $(".edte-submenu-add").click(function() {
    var menuName = $("#edte-submenu-name").val();
    if (menuName == "") {
      $(".editsubmenu-mesg").text("菜单名字不能为空");
      $(".edit-submenu-mesg").hide();
      $(".editsubmenu-mesg").show();
      return false;
    }
    var length = 0;
    for (var i = 0; i < menuName.length; i++) {
      var menuNameLength = menuName.charCodeAt(i);
      if (menuNameLength >= 0 && menuNameLength <= 128) {
        length += 1;
      } else {
        length += 2;
      }
    }
    if (length > 16) {
      $(".editsubmenu-mesg").text("超出字数范围");
      $(".edit-submenu-mesg").hide();
      $(".editsubmenu-mesg").show();
      return false;
    }
  });
  $("#edte-submenu-name").focus(function() {
    $(".edit-submenu-mesg").show();
    $(".editsubmenu-mesg").hide();
  });

  /*
  二级菜单删除
  */

  // 对于一级菜单删除通用.
  $('.delete-submenu-btn').on('click', function() {
    _id = $(this).data("id");
    if (_id !== undefined && _id !== '') {
      if (confirm("确定删除吗")) {
        $.ajax({
          type: "GET",
          url: "/admin/wx_menus/" + _id + "/del/json",
          dataType: "json",
          success: function(data) {
            if (data.status == 'success') {
              alert(data.msg);
              _href = window.location.href;
              window.location.href = _href;
            } else {
              alert(data.msg);
            }
          },
          complete: function(XMLHttpRequest, textStatus) {
            // code
          },
          error: function() {
            // code
          }
        });
      }
    }
    return false;
  });

  /*
  二级菜单选择
  */
  $(".submenu").click(function() {
    var type = $(this).data("type");
    if (type == 0) {
      $(".edit-url").hide();
      $(".edit-mesg").hide();
      $(".select-action").show();
    }
    if (type == 1) {
      $(".select-action").hide();
      $(".edit-mesg").hide();
      $(".edit-url").show();
    }
    if (type == 2) {
      $(".select-action").hide();
      $(".edit-url").hide();
      $(".edit-mesg").show();
    }
  });


  /*
  微信动作选择
  */
  $(".add-mesg").click(function() {
    $(".select-action").hide();
    $(".edit-url").show();
  });

  $(".add-url").click(function() {
    $(".select-action").hide();
    $(".edit-mesg").show();
  });
  /*
  文字
  */
  sendMessage();
  (function(bool) {
    //兼容FF一些方法
    var html;
    if (bool) {
      window.__defineGetter__("event", function() {
        //兼容Event对象
        var o = arguments.callee;
        do {
          if (o.arguments[0] instanceof Event) return o.arguments[0];
        } while (o = o.caller);
        return null;
      });

    }
  })(/Firefox/.test(window.navigator.userAgent));
  $(".icon_emotion").click(function() {
    $(".expression").fadeIn("500");
    (function(e) {
      var e = window.event || e;
      if (e.stopPropagation) e.stopPropagation();
      else e.cancelBubble = true;
    })(event)
  });
  $(".icon-emotion").click(function() {
    var imgPath = $(this).find(".expression-img").attr("src");
    var img = $("<img>").attr("src", imgPath).addClass("expression-img");
    $(".mesg-panel-text").append(img);
    (function(e) {
      var e = window.event || e;
      if (e.stopPropagation) e.stopPropagation();
      else e.cancelBubble = true;
    })(event)
  });
  $("body").click(function() {
    $(".expression").fadeOut("500");
  });

  /*
  菜单导航栏
  */
  $(".menu-list").click(function() {
    $(".menu-title").css("background", "#f3f3f3");
    $(this).parent().css("background", "#6CB160");
  });

  $(".menu-edit-add").click(function() {

  });

  /*
  设置动作导航
  */
  $(".edit-word").click(function() {
    $(this).css("background", "#fff");
    $(this).css("borderTop", "2px solid #5CA849");
    $(".edit-pic-body").hide();
    $(".edit-graphic-body").hide();
    $(".edit-picture").css("borderTop", "0");
    $(".edit-picture").css("background", "#ececec");
    $(".edit-graphic").css("borderTop", "0");
    $(".edit-graphic").css("background", "#ececec");
    $(".edit-mesg-body").show();
  });

  $(".edit-picture").click(function() {
    $(this).css("background", "#fff");
    $(this).css("borderTop", "2px solid #5CA849");
    $(".edit-word").css("borderTop", "0");
    $(".edit-word").css("background", "#ececec");
    $(".edit-graphic").css("borderTop", "0");
    $(".edit-graphic").css("background", "#ececec");;
    $(".edit-mesg-body").hide();
    $(".edit-graphic-body").hide();
    $(".edit-pic-body").show();
  });

  $(".edit-graphic").click(function() {
    $(this).css("background", "#fff");
    $(this).css("borderTop", "2px solid #5CA849");
    $(".edit-word").css("borderTop", "0");
    $(".edit-word").css("background", "#ececec");
    $(".edit-picture").css("borderTop", "0");
    $(".edit-picture").css("background", "#ececec");
    $(".edit-mesg-body").hide();
    $(".edit-pic-body").hide();
    $(".edit-graphic-body").show();
  });


  /*
  上传图片
  */
  $(".upload-pic-btn").click(function() {
    $("#fileupload").trigger("click");
    $("#fileupload").fileupload({
      url: "/admin/answers/" + question_img_id + "/img/update/json",
      done: function(e, result) {
        console.log(JSON.stringify(result.result));
        if (result.result.status == "success") {
          var imgUrl = result.result.data;
          imgNode.html('<img src="' + imgUrl + '" class="q-img" />');
        } else {
          alert("上传失败");
        }
      }
    });
    return false;
  });

  /*
  上传图文
  */
  $(".select-graphic").click(function() {
    var selectGraphicFlag = $(this).find(".selectGraphicFlag").attr("value");
    if (selectGraphicFlag == "true") {
      $(this).children(".graphic-item").addClass("graphic-item-ba");
      $(this).find(".graphic-select-ico").show();
      $(this).find(".selectGraphicFlag").attr("value", "false");
    } else {
      $(this).children(".graphic-item").removeClass("graphic-item-ba");
      $(this).find(".graphic-select-ico").hide();
      $(this).find(".selectGraphicFlag").attr("value", "true");
    }
  });

  /*
  发送文字
  */
  function sendMessage() {
    $(".mesg-save").on('click', function() {
      var data = {
        "0": "/微笑",
        "1": "/撇嘴",
        "2": "/色",
        "3": "/发呆",
        "4": "/得意",
        "5": "/流泪",
        "6": "/害羞",
        "7": "/闭嘴",
        "8": "/睡",
        "9": "/大哭",
        "10": "/尴尬",
        "11": "/发怒",
        "12": "/调皮",
        "13": "/呲牙",
        "14": "/惊讶",
        "15": "/难过",
        "16": "/酷",
        "17": "/冷汗",
        "18": "/抓狂",
        "19": "/吐",
        "20": "/偷笑",
        "21": "/可爱",
        "22": "/白眼",
        "23": "/傲慢",
        "24": "/饥饿",
        "25": "/困",
        "26": "/惊恐",
        "27": "/流汗",
        "28": "/憨笑",
        "29": "/大兵",
        "30": "/奋斗",
        "31": "/咒骂",
        "32": "/疑问",
        "33": "/嘘",
        "34": "/晕",
        "35": "/折磨",
        "36": "/衰",
        "37": "/骷髅",
        "38": "/敲打",
        "39": "/再见",
        "40": "/擦汗",
        "41": "/抠鼻",
        "42": "/鼓掌",
        "43": "/糗大了",
        "44": "/坏笑",
        "45": "/左哼哼",
        "46": "/右哼哼",
        "47": "/哈欠",
        "48": "/鄙视",
        "49": "/委屈",
        "50": "/快哭了",
        "51": "/阴险",
        "52": "/亲亲",
        "53": "/吓",
        "54": "/可怜",
        "55": "/菜刀",
        "56": "/西瓜",
        "57": "/啤酒",
        "58": "/篮球",
        "59": "/乒乓",
        "60": "/咖啡",
        "61": "/饭",
        "62": "/猪头",
        "63": "/玫瑰",
        "64": "/凋谢",
        "65": "/示爱",
        "66": "/爱心",
        "67": "/心碎",
        "68": "/蛋糕",
        "69": "/闪电",
        "70": "/炸弹",
        "71": "/刀",
        "72": "/足球",
        "73": "/瓢虫",
        "74": "/便便",
        "75": "/月亮",
        "76": "/太阳",
        "77": "/礼物",
        "78": "/拥抱",
        "79": "/强",
        "80": "/弱",
        "81": "/握手",
        "82": "/胜利",
        "83": "/抱拳",
        "84": "/勾引",
        "85": "/拳头",
        "86": "/差劲",
        "87": "/爱你",
        "88": "/NO",
        "89": "/OK",
        "90": "/爱情",
        "91": "/飞吻",
        "92": "/跳跳",
        "93": "/发抖",
        "94": "/怄火",
        "95": "/转圈",
        "96": "/磕头",
        "97": "/回头",
        "98": "/跳绳",
        "99": "/挥手",
        "100": "/激动",
        "101": "/街舞",
        "102": "/献吻",
        "103": "/左太极",
        "104": "/右太极"
      };
      var replyContent = $(".mesg-panel-text").html();
      var that = $(this);
      for (i = 0; i < 105; i++) {
        var code = "" + i + ".gif\">";
        var re = new RegExp("<img class=\"expression-img\" src=\"https://res.wx.qq.com/mpres/htmledition/images/icon/emotion/" + code, "g");
        replyContent = replyContent.replace(re, data[i]);
      }
    });
  }
});



(function() {
  $(document).on('ready page:load', function() {
    $.fn.editable.defaults.mode = 'popup';
    $('.wx-menu-editable').editable();
/*
    $('.publish-menu').on('click', function() {
      $.ajax({
        type: "GET",
        url: "/admin/weixin/menus/create/json",
        dataType: "json",
        success: function(data) {
          alert(data.msg);
        },
        complete: function(XMLHttpRequest, textStatus) {
          // code
        },
        error: function() {
          // code
        }
      });
      return false;
    });

    $('.sub-menu-add').on('click', function() {
      parent_id = $(this).data("id");
      $("input[name=parent_id]").val(parent_id);
    });
*/
    $('.menu-add').on('click', function() {
      _name = $("input[name=name]").val();
      _url = $("input[name=url]").val();
      _p_id = $("input[name=parent_id]").val();
      if (_name === '' || _url === '' || _p_id === '') {
        alert("请填写完整");
      } else {
        $.ajax({
          type: "POST",
          url: "/admin/wx_menus/create/json",
          dataType: "json",
          data: {
            name: _name,
            url: _url,
            parent_id: _p_id,
            level: 2
          },
          success: function(data) {
            if (data.status == 'success') {
              alert(data.msg);
              _href = window.location.href;
              window.location.href = _href;
            } else {
              alert(data.msg);
            }
          },
          complete: function(XMLHttpRequest, textStatus) {
            // code
          },
          error: function() {
            // code
          }
        });
      }
      return false;
    });
  });
}).call(this);
