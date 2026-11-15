(function () {
    const statusEl = document.getElementById('status');
    const registryEl = document.getElementById('registry');
    const filterButtons = document.querySelectorAll('.filter-btn');

    const categoryLabels = {
        OwnStallion: 'Свои жеребцы-производители',
        ManagedStallion: 'Жеребцы на управлении',
        ClientHorse: 'Лошади клиентов'
    };

    const categoryOrder = ['OwnStallion', 'ManagedStallion', 'ClientHorse'];

    let currentCategory = '';

    async function loadHorses(category) {
        statusEl.textContent = 'Загрузка…';
        registryEl.innerHTML = '';

        const url = category
            ? '/api/horses?category=' + encodeURIComponent(category)
            : '/api/horses';

        try {
            const res = await fetch(url);
            if (!res.ok) {
                statusEl.textContent = 'Ошибка загрузки (' + res.status + ')';
                return;
            }
            const items = await res.json();
            render(items, category);
            statusEl.textContent = items.length
                ? 'Найдено: ' + items.length
                : 'Нет лошадей в этой категории';
        } catch (e) {
            statusEl.textContent = 'Не удалось связаться с API: ' + e.message;
        }
    }

    function render(items, filterCategory) {
        if (!items.length) {
            registryEl.innerHTML = '<p class="empty">Список пуст</p>';
            return;
        }

        const groups = {};
        for (const h of items) {
            (groups[h.category] ||= []).push(h);
        }

        const sections = (filterCategory ? [filterCategory] : categoryOrder)
            .filter(cat => groups[cat] && groups[cat].length);

        registryEl.innerHTML = sections.map(cat => {
            const rows = groups[cat].map(h => `
                <tr>
                    <td class="name"><a href="/horse?id=${h.id}">${escapeHtml(h.name)}</a></td>
                    <td>${escapeHtml(h.sex)}</td>
                    <td>${escapeHtml(h.breed)}</td>
                    <td>${escapeHtml(h.color)}</td>
                    <td>${h.dateOfBirth || '—'}</td>
                    <td>${escapeHtml(h.ownerName || '—')}</td>
                    <td class="actions">
                        <a class="link-muted" href="/horse?id=${h.id}">карточка</a>
                    </td>
                </tr>
            `).join('');

            return `
                <section class="horse-section">
                    <h2>${categoryLabels[cat] || cat}
                        <span class="count">${groups[cat].length}</span>
                    </h2>
                    <div class="table-wrap">
                        <table class="horse-table">
                            <thead>
                                <tr>
                                    <th>Кличка</th>
                                    <th>Пол</th>
                                    <th>Порода</th>
                                    <th>Масть</th>
                                    <th>Дата рожд.</th>
                                    <th>Владелец</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>${rows}</tbody>
                        </table>
                    </div>
                </section>
            `;
        }).join('');
    }

    function escapeHtml(s) {
        if (s == null) return '';
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    filterButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            filterButtons.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentCategory = btn.dataset.category || '';
            loadHorses(currentCategory);
        });
    });

    loadHorses('');
})();