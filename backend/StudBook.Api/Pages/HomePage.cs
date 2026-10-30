namespace StudBook.Api.Pages;

public static class HomePage
{
    public static string Html => """
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Stud Book</title>
    <style>
        body { font-family: Georgia, serif; max-width: 600px; margin: 80px auto; background: #f7f3eb; color: #2c2c2c; }
        h1 { color: #5c4033; }
        a { display: block; margin: 12px 0; color: #8b4513; }
        .card { background: #fff; padding: 24px; border: 1px solid #d2b48c; border-radius: 8px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Stud Book</h1>
        <p>Breeding management system (skeleton)</p>
        <a href="/login">Login / Select role</a>
        <a href="/health">Health check</a>
        <a href="/openapi/v1.json">OpenAPI</a>
    </div>
</body>
</html>
""";
}