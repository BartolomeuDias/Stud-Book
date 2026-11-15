(function () {
    const statusEl = document.getElementById('status');
    const tableEl = document.getElementById('rules-table');
    const bodyEl = document.getElementById('rules-body');
    const saveMsg = document.getElementById('save-msg');

    const sourceLabels = {
        TeamDraft: 'Черновик команды',
        CustomerConfirmed: 'Согласовано'
    };

    function escapeHtml(s) {
        if (s == null) return '';
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    function thresholdPlaceholder(r) {
        // правила без unit — порог не используется
        if (!r.thresholdUnit) return 'не используется';
        return '—';
    }

    function render(rules) {
        bodyEl.innerHTML = rules.map(r => {
            const hasThreshold = !!r.thresholdUnit;
            const thresholdVal = r.threshold == null ? '' : r.threshold;

            return `
            <tr data-id="${r.id}" data-has-threshold="${hasThreshold ? '1' : '0'}">
                <td class="col-priority">
                    <input class="input-priority" type="number" min="1" value="${r.priority}">
                </td>
                <td class="col-code"><code>${escapeHtml(r.code)}</code></td>
                <td class="col-text">${escapeHtml(r.description)}</td>
                <td class="col-text">${escapeHtml(r.denialMessage)}</td>
                <td class="col-threshold">
                    ${hasThreshold
                        ? `<input class="input-threshold" type="number" min="0" value="${thresholdVal}" placeholder="—">
                           <div class="unit">${escapeHtml(r.thresholdUnit)}</div>`
                        : `<span class="muted">—</span>
                           <input class="input-threshold" type="hidden" value="">`
                    }
                </td>
                <td class="col-source">
                    <select class="input-source">
                        <option value="TeamDraft" ${r.source === 'TeamDraft' ? 'selected' : ''}>Черновик</option>
                        <option value="CustomerConfirmed" ${r.source === 'CustomerConfirmed' ? 'selected' : ''}>Согласовано</option>
                    </select>
                </td>
                <td class="col-active">
                    <label class="check-active">
                        <input class="input-active" type="checkbox" ${r.isActive ? 'checked' : ''}>
                        <span>${r.isActive ? 'да' : 'нет'}</span>
                    </label>
                    <button type="button" class="btn-save-row filter-btn">Сохранить</button>
                </td>
            </tr>`;
        }).join('');

        bodyEl.querySelectorAll('.btn-save-row').forEach(btn => {
            btn.addEventListener('click', () => saveRow(btn.closest('tr')));
        });

        bodyEl.querySelectorAll('.input-active').forEach(cb => {
            cb.addEventListener('change', () => {
                const span = cb.parentElement.querySelector('span');
                if (span) span.textContent = cb.checked ? 'да' : 'нет';
            });
        });
    }

    async function saveRow(tr) {
        const id = tr.dataset.id;
        const hasThreshold = tr.dataset.hasThreshold === '1';
        const priority = Number(tr.querySelector('.input-priority').value);
        const thresholdInput = tr.querySelector('.input-threshold');
        const thresholdRaw = thresholdInput ? thresholdInput.value.trim() : '';

        const body = {
            isActive: tr.querySelector('.input-active').checked,
            priority: priority,
            // только если у правила есть unit; иначе явно сбрасываем порог
            threshold: hasThreshold
                ? (thresholdRaw === '' ? null : Number(thresholdRaw))
                : null,
            thresholdUnit: hasThreshold ? undefined : '', // '' = очистить unit не трогаем source path; для no-unit не шлём unit
            source: tr.querySelector('.input-source').value
        };

        // для правил без порога не отправляем thresholdUnit, чтобы не затереть null в БД лишним
        if (!hasThreshold) {
            body.threshold = null;
            // не отправляем thresholdUnit — в API null = «не менять»
            delete body.thresholdUnit;
        }

        saveMsg.textContent = 'Сохранение…';
        try {
            const res = await fetch('/api/compatibility-rules/' + id, {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });
            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                saveMsg.textContent = data.error || ('Ошибка ' + res.status);
                return;
            }
            saveMsg.textContent = 'Сохранено: ' + data.code;
            setTimeout(() => { saveMsg.textContent = ''; }, 2000);
        } catch (e) {
            saveMsg.textContent = 'Сеть: ' + e.message;
        }
    }

    async function load() {
        try {
            const res = await fetch('/api/compatibility-rules');
            if (!res.ok) {
                statusEl.textContent = 'Ошибка загрузки (' + res.status + ')';
                return;
            }
            const rules = await res.json();
            statusEl.textContent = rules.length
                ? 'Правил: ' + rules.length + ' (порядок = приоритет применения)'
                : 'Правил пока нет';
            render(rules);
            tableEl.hidden = false;
        } catch (e) {
            statusEl.textContent = 'Не удалось связаться с API: ' + e.message;
        }
    }

    load();
})();