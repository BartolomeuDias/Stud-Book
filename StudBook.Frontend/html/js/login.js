async function login(email) {
    const result = document.getElementById('result');

    const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email })
    });

    // При 401 тело ответа пустое — res.json() упал бы, поэтому сначала проверяем статус
    if (!res.ok) {
        result.textContent = 'Login failed (' + res.status + ')';
        return;
    }

    const data = await res.json();
    result.textContent = JSON.stringify(data, null, 2);

    location.href = data.user.role === 'Client' ? '/client' : '/staff';
}
