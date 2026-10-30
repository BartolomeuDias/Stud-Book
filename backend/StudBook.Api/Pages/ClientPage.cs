namespace StudBook.Api.Pages;

public static class ClientPage
{
    public static string Html => """
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Client — Stud Book</title>
    <style>
        body { font-family: Georgia, serif; max-width: 600px; margin: 80px auto; background: #f7f3eb; }
        .card { background: #fff; padding: 32px; border: 1px solid #d2b48c; border-radius: 8px; }
        h1 { color: #5c4033; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Client Home</h1>
        <p>Role: Client (mare owner)</p>
        <p>This is a skeleton page. Breeding requests will appear here later.</p>
        <a href="/login">Switch role</a>
    </div>
</body>
</html>
""";
}