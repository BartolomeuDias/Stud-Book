(function () {
    const form = document.getElementById('form');
    const errorEl = document.getElementById('form-error');
    const categoryEl = document.getElementById('category');
    const ownerField = document.getElementById('owner-field');
    const ownerSelect = document.getElementById('ownerClientId');
    const sireSelect = document.getElementById('sireId');
    const damSelect = document.getElementById('damId');

    function showError(msg) {
        errorEl.hidden = !msg;
        errorEl.textContent = msg || '';
    }

    function toggleOwner() {
        const cat = categoryEl.value;
        const needOwner = cat === 'ManagedStallion' || cat === 'ClientHorse';
        ownerField.style.opacity = needOwner ? '1' : '0.55';
        if (!needOwner) ownerSelect.value = '';
    }

    categoryEl.addEventListener('change', toggleOwner);
    toggleOwner();

    async function loadOptions() {
        const [clientsRes, horsesRes] = await Promise.all([
            fetch('/api/clients'),
            fetch('/api/horses')
        ]);

        if (clientsRes.ok) {
            const clients = await clientsRes.json();
            for (const c of clients) {
                const opt = document.createElement('option');
                opt.value = c.id;
                opt.textContent = c.name + ' (' + c.type + ')';
                ownerSelect.appendChild(opt);
            }
        }

        if (horsesRes.ok) {
            const horses = await horsesRes.json();
            for (const h of horses) {
                const label = h.name + (h.registrationNumber ? ' · ' + h.registrationNumber : '');
                if (h.sex === 'Stallion') {
                    const opt = document.createElement('option');
                    opt.value = h.id;
                    opt.textContent = label;
                    sireSelect.appendChild(opt);
                }
                if (h.sex === 'Mare') {
                    const opt = document.createElement('option');
                    opt.value = h.id;
                    opt.textContent = label;
                    damSelect.appendChild(opt);
                }
            }
        }
    }

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        showError('');

        const fd = new FormData(form);
        const body = {
            name: fd.get('name'),
            category: fd.get('category'),
            sex: fd.get('sex'),
            breed: fd.get('breed'),
            color: fd.get('color'),
            dateOfBirth: fd.get('dateOfBirth') || null,
            registrationNumber: fd.get('registrationNumber') || null,
            ownerClientId: fd.get('ownerClientId') ? Number(fd.get('ownerClientId')) : null,
            sireId: fd.get('sireId') ? Number(fd.get('sireId')) : null,
            damId: fd.get('damId') ? Number(fd.get('damId')) : null,
            notes: fd.get('notes') || ''
        };

        try {
            const res = await fetch('/api/horses', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                showError(data.error || ('Ошибка ' + res.status));
                return;
            }
            location.href = '/horse?id=' + data.id;
        } catch (err) {
            showError('Не удалось связаться с API: ' + err.message);
        }
    });

    loadOptions().catch(err => showError('Не удалось загрузить справочники: ' + err.message));
})();