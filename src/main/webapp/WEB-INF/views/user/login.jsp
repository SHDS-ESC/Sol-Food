<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <script>
        let msg = '${msg}';
        if (msg) {
            alert(msg);
        }
    </script>
</head>
<body>
<h1>로그인</h1>

<a id="login-kakao-btn"
   class="kakao"
   href="https://kauth.kakao.com/oauth/authorize?client_id=5d4b8480ccbf31d3c2c6cca2fae79fd6&redirect_uri=http://localhost:8080/solfood/user/kakaoLogin&response_type=code">
    <img src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg"
         alt="카카오 로그인 버튼"
         width="222"/>
</a>

</body>
</html>