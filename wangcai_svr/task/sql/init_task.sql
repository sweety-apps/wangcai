

INSERT INTO task_app SET \
            appid = '723564814', \
            app_name = '窃听风云', \
            download_url = 'https://itunes.apple.com/cn/app/qie-ting-feng-yun/id723564814?mt=8', \
            redirect_url = 'http://vod.xunlei.com', \
            icon = 'http://a1.mzstatic.com/us/r30/Purple6/v4/2b/e6/f1/2be6f17c-5ec7-b15e-4a20-06197abc3675/mzl.htefdfxe.175x175-75.jpg', \
            filesize = 100000000, \
            version = '1.3';

INSERT INTO task_base SET \
            id = 10000, \
            type = 10000, \
            title = '窃听风云', \
            icon = 'http://a1.mzstatic.com/us/r30/Purple6/v4/2b/e6/f1/2be6f17c-5ec7-b15e-4a20-06197abc3675/mzl.htefdfxe.175x175-75.jpg', \
            intro = '立即安装窃听风云即可获得1000元', \
            descr = '即日起安装窃听风云并通关100遍，到深圳南山区田夏国际1528领取属于您的1000元奖励！！', \
            steps = '在APPSTORE安装|游戏内注册|领取红包', \
            money = 1000, \
            insert_time = NOW();


INSERT INTO task_base SET \
           id = 1, \
           type = 1, \
           title = '安装旺财', \
           icon = '', \
           intro = '安装旺财获得1元红包', \
           descr = '安装旺财获得1元红包', \
           steps = '', \
           money = 100, \
           insert_time = NOW();


INSERT INTO task_base SET \
           id = 2, \
           type = 2, \
           title = '填写个人资料', \
           icon = '', \
           intro = '填写个人资料即可获得1元红包', \
           descr = '填写个人资料即可获得1元红包', \
           steps = '', \
           money = 100, \
           insert_time = NOW();
           
