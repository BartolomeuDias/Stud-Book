(function () {
    const form = document.getElementById('form');
    const statusEl = document.getElementById('status');
    const errorEl = document.getElementById('form-error');
    const subtitleEl = document.getElementById('subtitle');
    const categoryEl = document.getElementById('category');
    const ownerField = document.getElementById('owner-field');
    const ownerSelect = document.getElementById('ownerClientId');
    const sireSelect = document.getElementById('sireId');
    const damSelect = document.getElementById('damId');
    const linkCard = document.getElementById('link-card');
    const linkCancel = document.getElementById('link-cancel');

    function getId() {
        const id = parseInt(new URLSearchParams(location.search).get('id'), 10);
        return Number.isFinite(id) && id > 0 ? id : null;
    }

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

    function fillSelect(select, items, valueKey, labelFn, selectedId) {
        // оставляем первый option «не указан»
        while (select.options.length > 1) select.remove(1);
        for (const item of items) {
            const opt = document.createElement('option');
            opt.value = item[valueKey];
            opt.textContent = labelFn(item);
            if (selectedId != null && Number(item[valueKey]) === Number(selectedId))
                opt.selected = true;
            select.appendChild(opt);
        }
    }

    async function init(id) {
        linkCard.href = '/horse?id=' + id;
        linkCancel.href = '/horse?id=' + id;

        const [cardRes, clientsRes, horsesRes] = await Promise.all([
            fetch('/api/horses/' + id),
            fetch('/api/clients'),
            fetch('/api/horses')
        ]);

        if (cardRes.status === 404) {
            statusEl.textContent = 'Лошадь не найдена';
            return;
        }
        if (!cardRes.ok) {
            statusEl.textContent = 'Ошибка загрузки (' + cardRes.status + ')';
            return;
        }

        const card = await cardRes.json();
        subtitleEl.textContent = card.name;

        const clients = clientsRes.ok ? await clientsRes.json() : [];
        const horses = horsesRes.ok ? await horsesRes.json() : [];

        fillSelect(ownerSelect, clients, 'id', c => c.name + ' (' + c.type + ')', card.ownerClientId);

        const stallions = horses.filter(h => h.sex === 'Stallion' && h.id !== id);
        const mares = horses.filter(h => h.sex === 'Mare' && h.id !== id);
        const sireId = card.pedigree && card.pedigree.sire ? card.pedigree.sire.id : null;
        const damId = card.pedigree && card.pedigree.dam ? card.pedigree.dam.id : null;

        fillSelect(sireSelect, stallions, 'id', h => h.name, sireId);
        fillSelect(damSelect, mares, 'id', h => h.name, damId);

        form.name.value = card.name || '';
        form.category.value = card.category || 'ClientHorse';
        form.sex.value = card.sex || 'Mare';
        form.breed.value = card.breed || '';
        form.color.value = card.color || '';
        form.dateOfBirth.value = card.dateOfBirth || '';
        form.registrationNumber.value = card.registrationNumber || '';
        form.notes.value = card.notes || '';

        toggleOwner();
        statusEl.textContent = '';
        form.hidden = false;
    }

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        showError('');
        const id = getId();
        if (!id) return;

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
            const res = await fetch('/api/horses/' + id, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                showError(data.error || ('Ошибка ' + res.status));
                return;
            }
            location.href = '/horse?id=' + id;
        } catch (err) {
            showError('Не удалось связаться с API: ' + err.message);
        }
    });

    const id = getId();
    if (!id) {
        statusEl.textContent = 'Не указан id.';
        return;
    }
    init(id).catch(err => {
        statusEl.textContent = 'Ошибка: ' + err.message;
    });
})();