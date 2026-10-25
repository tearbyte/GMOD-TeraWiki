
# TeraLib Wiki

[Русская версия](#русская-версия)

An interactive in-game wiki for [TeraLib](https://steamcommunity.com/sharedfiles/filedetails/?id=3013984464) and the addons built on it, a page of the TeraLib settings window.

## Features

- **For players and developers.** Every page is marked with its audience, the navigation filters by it.
- **Live examples.** An example runs its code into a panel: the components on the page are real, and the code under them is exactly what built them. **Run again** rebuilds an example, an error is shown instead of the example without breaking the page.
- **Code blocks** with Lua highlighting in the theme colors. Drag the mouse to select a part of the code, Ctrl+C or **Copy** copies the selection, **Copy** without one copies the whole block.
- **Sections of other addons.** Any addon adds its pages if the wiki is installed. The navigation is rebuilt when new pages appear, so the load order doesn't matter.
- **Navigation** by collapsible sections with a search.
- Pages of TeraLib itself: getting started, the settings window and themes, every VGUI component, localization, notifications, database, network, logger, writing wiki pages.
- Languages: English, Russian, Ukrainian, both the interface and the pages. Other languages fall back to English.

## Installation

1. Install [TeraLib](https://steamcommunity.com/sharedfiles/filedetails/?id=3013984464).
2. Drop this folder into `garrysmod/addons/`.

## Usage

Open the TeraLib settings (`teralib_settings`, or the icon in the context menu) and choose **Wiki**, or use the `teralib_wiki` command.

## Adding pages of your addon

```lua
-- client/wiki_en.lua, the same for every language
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Section', 'My addon' )
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Usage.Title', 'How to use' )
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Usage.Text1', 'Open the menu with !menu.' )
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Usage.Hello', 'Hello' )

-- client/wiki.lua
hook.Add( 'InitPostEntity', 'MyAddon.Wiki', function()

	if not TeraLibWiki then return end

	TeraLibWiki.AddSection( { id = 'my_addon', title = 'MyAddon.Wiki.Section', icon = 'icon16/plugin.png' } )

	TeraLibWiki.AddPage( {
		section = 'my_addon',
		id = 'usage',
		audience = TeraLibWiki.AUDIENCE_PLAYERS,
		title = 'MyAddon.Wiki.Usage.Title',
		blocks = {
			{ type = 'text', text = 'MyAddon.Wiki.Usage.Text1' },
			{ type = 'example', height = 40, code = 'TeraLib.vgui.Label( { parent = parent, dock = FILL, text = TeraLib.lang.GetPhrase( "MyAddon.Wiki.Usage.Hello" ) } )' },
		},
	} )

end )
```

Register on `InitPostEntity`: the wiki is loaded by then for sure, whatever the load order of the addons is.

### API

| Function | Description |
|---|---|
| `TeraLibWiki.AddSection( { id, title, icon, order } )` | Add a section or replace one with the same id, its pages are kept |
| `TeraLibWiki.AddPage( { section, id, title, audience, order, blocks } )` | Add a page or replace one with the same id |
| `TeraLibWiki.Open( [sectionId, pageId] )` | Open the wiki, on a page if given |
| `TeraLibWiki.AddBlockType( name, build )` | Add a block type: `build( parent, block )` creates its panel docked to `TOP` |
| `TeraLibWiki.AUDIENCE_PLAYERS`, `AUDIENCE_DEVELOPERS` | Audiences of the pages, a page without one is for everyone |

`order` sorts the sections and the pages (100 by default), then the titles do.

Every text is a `TeraLib.lang` phrase key: the titles, the texts of the blocks, the cells of the tables. Register the phrases with `TeraLib.lang.Add`, a file per language is the easiest to translate. English is the fallback of a missing translation, a string that isn't a key is shown as is.

### Blocks

| Type | Fields | Shows |
|---|---|---|
| `heading` | `text` | A heading |
| `text` | `text` | A paragraph wrapped by width |
| `note` | `text` | A highlighted remark |
| `code` | `code` | Lua code with highlighting, selection and a copy button |
| `table` | `columns`, `rows` | A table of texts |
| `example` | `code`, `height` | Runs the code into a panel, then shows the code. The panel is the `parent` variable of the code, `height` is in pixels at 1080p |

## Project structure

```
lua/
├── autorun/teralib_wiki.lua    loader, client only
└── teralib_wiki/client/
    ├── lang/                   phrases of the interface and the pages, a file per language
    ├── api.lua                 registry of sections and pages
    ├── highlight.lua           Lua syntax highlighting
    ├── blocks.lua              block types
    ├── ui.lua                  the settings page
    └── pages/                  the TeraLib pages
```

---

# Русская версия

Интерактивная внутриигровая вики для [TeraLib](https://steamcommunity.com/sharedfiles/filedetails/?id=3013984464) и аддонов на ней — страница окна настроек TeraLib.

## Возможности

- **Для игроков и разработчиков.** У каждой страницы отмечена аудитория, навигация фильтрует по ней.
- **Живые примеры.** Пример выполняет свой код в панели: компоненты на странице настоящие, а код под ними — ровно тот, что их построил. **«Заново»** пересобирает пример, ошибка показывается вместо примера и не ломает страницу.
- **Блоки кода** с подсветкой Lua в цветах темы. Выделите часть кода мышью — Ctrl+C или **«Копировать»** скопирует выделение, **«Копировать»** без выделения копирует весь блок.
- **Разделы других аддонов.** Любой аддон добавляет свои страницы, если вики установлена. Навигация перестраивается, когда появляются новые страницы, так что порядок загрузки неважен.
- **Навигация** по сворачиваемым разделам с поиском.
- Страницы самой TeraLib: начало работы, окно настроек и темы, все компоненты VGUI, локализация, уведомления, БД, сеть, логгер, написание страниц вики.
- Языки: английский, русский, украинский — и интерфейс, и страницы. Остальные языки используют английский.

## Установка

1. Установите [TeraLib](https://steamcommunity.com/sharedfiles/filedetails/?id=3013984464).
2. Положите эту папку в `garrysmod/addons/`.

## Использование

Откройте настройки TeraLib (`teralib_settings` или иконка в контекстном меню) и выберите **Вики** или используйте команду `teralib_wiki`.

## Страницы своего аддона

```lua
-- client/wiki_en.lua, the same for every language
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Section', 'My addon' )
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Usage.Title', 'How to use' )
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Usage.Text1', 'Open the menu with !menu.' )
TeraLib.lang.Add( 'en', 'MyAddon.Wiki.Usage.Hello', 'Hello' )

-- client/wiki.lua
hook.Add( 'InitPostEntity', 'MyAddon.Wiki', function()

	if not TeraLibWiki then return end

	TeraLibWiki.AddSection( { id = 'my_addon', title = 'MyAddon.Wiki.Section', icon = 'icon16/plugin.png' } )

	TeraLibWiki.AddPage( {
		section = 'my_addon',
		id = 'usage',
		audience = TeraLibWiki.AUDIENCE_PLAYERS,
		title = 'MyAddon.Wiki.Usage.Title',
		blocks = {
			{ type = 'text', text = 'MyAddon.Wiki.Usage.Text1' },
			{ type = 'example', height = 40, code = 'TeraLib.vgui.Label( { parent = parent, dock = FILL, text = TeraLib.lang.GetPhrase( "MyAddon.Wiki.Usage.Hello" ) } )' },
		},
	} )

end )
```

Регистрируйте страницы на `InitPostEntity`: к этому моменту вики точно загружена, каким бы ни был порядок загрузки аддонов.

### API

| Функция | Описание |
|---|---|
| `TeraLibWiki.AddSection( { id, title, icon, order } )` | Добавить раздел или заменить раздел с тем же id, его страницы сохраняются |
| `TeraLibWiki.AddPage( { section, id, title, audience, order, blocks } )` | Добавить страницу или заменить страницу с тем же id |
| `TeraLibWiki.Open( [sectionId, pageId] )` | Открыть вики, на странице, если она задана |
| `TeraLibWiki.AddBlockType( name, build )` | Добавить тип блока: `build( parent, block )` создаёт его панель с `Dock( TOP )` |
| `TeraLibWiki.AUDIENCE_PLAYERS`, `AUDIENCE_DEVELOPERS` | Аудитории страниц, страница без аудитории — для всех |

`order` сортирует разделы и страницы (по умолчанию 100), затем сортировка идёт по названию.

Каждый текст — ключ фразы `TeraLib.lang`: названия, тексты блоков, ячейки таблиц. Регистрируйте фразы через `TeraLib.lang.Add`, по файлу на язык переводить проще всего. Английский — запасной для недостающего перевода, строка, которая не является ключом, показывается как есть.

### Блоки

| Тип | Поля | Показывает |
|---|---|---|
| `heading` | `text` | Заголовок |
| `text` | `text` | Абзац с переносом по ширине |
| `note` | `text` | Выделенное замечание |
| `code` | `code` | Код Lua с подсветкой, выделением и кнопкой «Копировать» |
| `table` | `columns`, `rows` | Таблица текстов |
| `example` | `code`, `height` | Выполняет код в панели, затем показывает код. Панель — переменная `parent` кода, `height` — в пикселях при 1080p |

## Структура

```
lua/
├── autorun/teralib_wiki.lua    загрузчик, только клиент
└── teralib_wiki/client/
    ├── lang/                   фразы интерфейса и страниц, по файлу на язык
    ├── api.lua                 реестр разделов и страниц
    ├── highlight.lua           подсветка синтаксиса Lua
    ├── blocks.lua              типы блоков
    ├── ui.lua                  страница в настройках
    └── pages/                  страницы TeraLib
```
