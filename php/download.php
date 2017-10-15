<?php
/**
    url 文本列表
    example:
    http://domain.com/1.jpg
    http://domain.com/2.jpg
    ...
    http://domain.com/N.jpg
**/
$list = file_get_contents('1.log');
$list = explode("\n", $list);

function get($url) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)');
    if (stripos($url, "https://") !== FALSE) {
      curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
      curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 2);
    }
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
}

foreach($list as $key => $url) {
    $response = get($url);
    $file_name = explode("/", $url);
    $file_name = $file_name[count($file_name) - 1];
    file_put_contents($file_name, $response);
}
