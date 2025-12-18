# Nuxt.js Best Practices

## Component Auto-Import Convention

Nuxt автоматически импортирует компоненты из `components/` директории.

### Правило именования папок

Компоненты в поддиректориях получают **префикс** из названия папки:

| Расположение | Использование в template |
|--------------|--------------------------|
| `components/BaseChip.vue` | `<BaseChip>` |
| `components/ui/BaseChip.vue` | `<UiBaseChip>` |
| `components/forms/Input.vue` | `<FormsInput>` |

### Пример

```vue
<!-- ✅ Правильно -->
<UiBaseChip label="Action" color="blue" />

<!-- ❌ Неправильно (компонент не найдется) -->
<BaseChip label="Action" />
```

### Ссылки

- [Nuxt Components Directory](https://nuxt.com/docs/guide/directory-structure/components)
