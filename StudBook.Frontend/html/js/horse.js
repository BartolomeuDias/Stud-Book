(function () {
    const statusEl = document.getElementById('status');
    const contentEl = document.getElementById('card-content');
    const nameEl = document.getElementById('horse-name');
    const subtitleEl = document.getElementById('horse-subtitle');
    const detailsEl = document.getElementById('details');
    const pedigreeEl = document.getElementById('pedigree');

    const categoryLabels = {
        OwnStallion: 'Свой жеребец-производитель',
        ManagedStallion: 'Жеребец на управлении',
        ClientHorse: 'Лошадь клиента',
        Ancestor: 'Предок (справочная запись)'
    };

    const sexLabels = {
        Stallion: 'Жеребец',
        Mare: 'Кобыла',
        Gelding: 'Мерин'
    };

    function getIdFromQuery() {
        const params = new URLSearchParams(window.location.search);
        const id = parseInt(params.get('id'), 10);
        return Number.isFinite(id) && id > 0 ? id : null;
    }

    function escapeHtml(s) {
        if (s == null) return '';
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    function row(label, value) {
        const v = value == null || value === '' ? '—' : escapeHtml(String(value));
        return `<dt>${escapeHtml(label)}</dt><dd>${v}</dd>`;
    }

    function nodeHtml(node, roleLabel) {
        if (!node) {
            return `
                <div class="pedigree-node empty">
                    <span class="pedigree-role">${escapeHtml(roleLabel)}</span>
                    <span class="pedigree-name">—</span>
                </div>`;
        }
        const sex = sexLabels[node.sex] || node.sex;
        const meta = [sex, node.breed, node.dateOfBirth].filter(Boolean).join(' · ');
        return `
            <div class="pedigree-node">
                <span class="pedigree-role">${escapeHtml(roleLabel)}</span>
                <a class="pedigree-name" href="/horse?id=${node.id}">${escapeHtml(node.name)}</a>
                <span class="pedigree-meta">${escapeHtml(meta)}</span>
            </div>`;
    }

    function renderDetails(card) {
        nameEl.textContent = card.name;
        subtitleEl.textContent =
            (categoryLabels[card.category] || card.category) +
            ' · ' +
            (sexLabels[card.sex] || card.sex);

        detailsEl.innerHTML = [
            row('Кличка', card.name),
            row('Категория', categoryLabels[card.category] || card.category),
            row('Пол', sexLabels[card.sex] || card.sex),
            row('Порода', card.breed),
            row('Масть', card.color),
            row('Дата рождения', card.dateOfBirth),
            row('Рег. номер', card.registrationNumber),
            row('Владелец', card.ownerName),
            row('Активна в реестре', card.isActive ? 'Да' : 'Нет'),
            row('Заметки', card.notes)
        ].join('');
    }

    function renderPedigree(p) {
        // Схема: деды/бабки сверху, родители, «пробанд» внизу по смыслу —
        // для HTML-заглушки делаем аккуратные три ряда.
        pedigreeEl.innerHTML = `
            <div class="pedigree-row grandparents">
                ${nodeHtml(p.paternalGrandsire, 'Дед (по отцу)')}
                ${nodeHtml(p.paternalGranddam, 'Бабка (по отцу)')}
                ${nodeHtml(p.maternalGrandsire, 'Дед (по матери)')}
                ${nodeHtml(p.maternalGranddam, 'Бабка (по матери)')}
            </div>
            <div class="pedigree-row parents">
                ${nodeHtml(p.sire, 'Отец')}
                ${nodeHtml(p.dam, 'Мать')}
            </div>
            <p class="pedigree-hint">Клик по кличке предка открывает его карточку (если запись есть в базе).</p>
        `;
    }

    async function load(id) {
        statusEl.textContent = 'Загрузка…';
        contentEl.hidden = true;

        try {
            const res = await fetch('/api/horses/' + id);
            if (res.status === 404) {
                statusEl.textContent = 'Лошадь с id=' + id + ' не найдена';
                nameEl.textContent = 'Не найдено';
                subtitleEl.textContent = '';
                return;
            }
            if (!res.ok) {
                statusEl.textContent = 'Ошибка загрузки (' + res.status + ')';
                return;
            }
            const card = await res.json();
            renderDetails(card);
            renderPedigree(card.pedigree || {});
            statusEl.textContent = '';
            contentEl.hidden = false;
            document.title = card.name + ' — Stud Book';
        } catch (e) {
            statusEl.textContent = 'Не удалось связаться с API: ' + e.message;
        }
    }

    const id = getIdFromQuery();
    if (!id) {
        statusEl.textContent = 'Не указан id. Откройте карточку из реестра.';
        subtitleEl.textContent = '';
        return;
    }
    load(id);

    // --- edit / delete ---
    const linkEdit = document.getElementById('link-edit');
    const btnDelete = document.getElementById('btn-delete');

    if (linkEdit) {
        linkEdit.href = '/horse-edit?id=' + id;
    }

    if (btnDelete) {
        btnDelete.addEventListener('click', async () => {
            if (!confirm('Убрать лошадь из реестра?\nЗапись сохранится для родословных, но в списке реестра отображаться не будет.')) {
                return;
            }
            try {
                const res = await fetch('/api/horses/' + id, { method: 'DELETE' });
                if (res.status === 404) {
                    alert('Лошадь не найдена');
                    return;
                }
                if (!res.ok) {
                    alert('Ошибка: ' + res.status);
                    return;
                }
                location.href = '/staff';
            } catch (e) {
                alert('Не удалось связаться с API: ' + e.message);
            }
        });
    }
})();