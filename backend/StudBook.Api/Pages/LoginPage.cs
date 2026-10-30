namespace StudBook.Api.Pages;

public static class LoginPage
{
    public static string Html => """
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Login — Stud Book</title>
    <style>
        body { font-family: Georgia, serif; max-width: 480px; margin: 80px auto; background: #f7f3eb; }
        .card { background: #fff; padding: 32px; border: 1px solid #d2b48c; border-radius: 8px; }
        h1 { color: #5c4033; margin-top: 0; }
        button { margin: 8px 8px 0 0; padding: 10px 16px; cursor: pointer; }
        #result { margin-top: 20px; white-space: pre-wrap; font-size: 14px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Login</h1>
        <p>Choose a demo account:</p>
        <button onclick="login('client@test.com')">Enter as Client</button>
        <button onclick="login('staff@test.com')">Enter as Ranch Staff</button>
        <div id="result"></div>
        <p style="margin-top:24px"><a href="/">← Back</a></p>
    </div>
    <script>
        async function login(email) {
            const res = await fetch('/api/auth/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email })
            });
            const data = await res.json();
            document.getElementById('result').textContent = JSON.stringify(data, null, 2);

            if (res.ok) {
                if (data.user.role === 'Client') location.href = '/client';
                else location.href = '/staff';
            }
        }
    </script>
</body>
</html>
""";
}