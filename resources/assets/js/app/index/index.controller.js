(function ()
{
    'use strict';

    angular.module('app.index')
           .controller('IndexController', IndexController);

    IndexController.$inject = ['api', '$sce'];

    function IndexController(api, $sce)
    {
        var vm = this;

        vm.video = [];
        vm.user = [];
        vm.fragment = [];

        // vm.fragments = [];
        // vm.cloudinary = [];

        vm.getVideoInfo = getVideoInfo;
        vm.getVideoEmbedUrl = getVideoEmbedUrl;
        vm.downloadVideo = downloadVideo;
        vm.uploadVideo = uploadVideo;

        vm.createFragment = createFragment;
        // vm.cloudinary = cloudinary;

        getUser();
        getFragment();

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Video
         |--------------------------------------------------------------------------------------------------------------
         */

        function getVideoInfo()
        {
            var data = {
                url: vm.fragment.url,
            };

            vm.video.isPreviewing = true;

            api.getVideoInfo(data).then(function (data)
            {
                vm.fragment.video_id = data.video_id;
                vm.fragment.start = 1;
                vm.fragment.end = data.end;
                vm.fragment.title = data.title;
                vm.fragment.description = data.description;
            });
        }


        function getVideoEmbedUrl()
        {
            var data = {
                url: vm.fragment.url,
                start: vm.fragment.start,
                end: vm.fragment.end
            };

            vm.video.isPreviewing = true;

            api.getVideoEmbedUrl(data).then(function (data)
            {
                vm.fragment.embed_url = $sce.trustAsResourceUrl(data);
            });
        }

        function downloadVideo()
        {
            var data = {
                id: vm.fragment.id
            };

            api.downloadVideo(data).then(function (data)
            {
                //
            });
        }

        function uploadVideo()
        {
            var data = {
                user_id: '28'
            };

            api.uploadVideo(data).then(function (data)
            {
                //
            });
        }

        // /*
        //  |--------------------------------------------------------------------------------------------------------------
        //  | Fragments Claudinary
        //  |--------------------------------------------------------------------------------------------------------------
        //  */
        //
        // function cloudinary()
        // {
        //     var data = {
        //         user_id: '28'
        //     };
        //
        //     api.cloudinary(data).then(function (data)
        //     {
        //         vm.cloudinary = data;
        //     });
        // }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Fragments
         |--------------------------------------------------------------------------------------------------------------
         */

        function createFragment()
        {
            var data = {
                url: vm.fragment.url,
                start: vm.fragment.start,
                end: vm.fragment.end,
                title: vm.fragment.title,
                description: vm.fragment.description,
                video_id: vm.fragment.video_id
            };

            api.createFragment(data).then(function (data)
            {
                vm.fragment = data;
                vm.fragment.isCreated = true;

                downloadVideo();
                // cloudinary();
                // uploaded();
            });
        }

        function getFragment()
        {
            api.getFragment().then(function (data)
            {
                vm.fragments = data;
            });
        }

        /*
         |--------------------------------------------------------------------------------------------------------------
         | Users
         |--------------------------------------------------------------------------------------------------------------
         */

        function getUser()
        {
            api.getUser().then(function (data)
            {
                vm.user = data;
            });
        }
    }
})();
