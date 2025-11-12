let currentDoc = null;
let currentFilter = '';
let classRegistry = new Map(); // Map of className -> {class, namespace}

if (WEB_URL != "") {
    document.querySelector('.file-selector').style.display = 'none';
    (async () => {
        const json = await fetch(WEB_URL);
        currentDoc = await json.json();
        buildClassRegistry(currentDoc);
        renderNavigation(currentDoc);
        updateDocTitle(WEB_URL.split('/').pop());
        showWelcomeMessage();
    })();
} else {
    // File input handler
    document.getElementById('jsonFile').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(event) {
                try {
                    currentDoc = JSON.parse(event.target.result);
                    buildClassRegistry(currentDoc);
                    renderNavigation(currentDoc);
                    updateDocTitle(file.name);
                    showWelcomeMessage();
                } catch (error) {
                    alert('Error parsing JSON file: ' + error.message);
                }
            };
            reader.readAsText(file);
        }
    });   
}

// Update document title with sanitized and capitalized filename
function updateDocTitle(filename) {
    const docTitleEl = document.getElementById('docTitle');
    if (!docTitleEl) return;

    // Remove extension and sanitize
    let name = filename.replace(/\.(json|JSON)$/, '');

    // Replace underscores and hyphens with spaces
    name = name.replace(/[_-]/g, ' ');

    // Capitalize each word
    name = name.split(' ')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
        .join(' ');

    docTitleEl.textContent = name;
}

// Search functionality
document.getElementById('searchInput').addEventListener('input', function(e) {
    currentFilter = e.target.value.toLowerCase();
    if (currentDoc) {
        renderNavigation(currentDoc);
    }
});

// Build a registry of all classes for type linking
function buildClassRegistry(doc) {
    classRegistry.clear();
    if (!doc.namespaces) return;

    doc.namespaces.forEach(namespace => {
        if (namespace.classes) {
            namespace.classes.forEach(clazz => {
                classRegistry.set(clazz.name, {
                    class: clazz,
                    namespace: namespace.name
                });
            });
        }
    });

}

// Render navigation sidebar
function renderNavigation(doc) {
    const nav = document.getElementById('navigation');
    nav.innerHTML = '';

    if (!doc.namespaces || doc.namespaces.length === 0) {
        nav.innerHTML = '<p class="placeholder">No namespaces found</p>';
        return;
    }

    doc.namespaces.forEach(namespace => {
        const section = document.createElement('div');
        section.className = 'nav-section';

        const title = document.createElement('h3');
        title.textContent = namespace.name;
        section.appendChild(title);

        // Classes
        if (namespace.classes && namespace.classes.length > 0) {
            const filteredClasses = filterItems(namespace.classes, 'name');
            if (filteredClasses.length > 0) {
                appendNavItems(section, 'Classes', filteredClasses, 'class', namespace.name);
            }
        }

        // Global Functions - grouped together
        if (namespace.functions && namespace.functions.length > 0) {
            const filteredFunctions = filterItems(namespace.functions, 'name');
            if (filteredFunctions.length > 0) {
                appendGlobalsNavItem(section, 'Globals', filteredFunctions, namespace);
            }
        }

        // Fields
        if (namespace.fields && namespace.fields.length > 0) {
            const filteredFields = filterItems(namespace.fields, 'name');
            if (filteredFields.length > 0) {
                appendNavItems(section, 'Fields', filteredFields, 'field', namespace.name);
            }
        }

        nav.appendChild(section);
    });

    initLucideIcons();
}

function filterItems(items, nameProperty) {
    if (!currentFilter) return items;
    return items.filter(item =>
        item[nameProperty].toLowerCase().includes(currentFilter)
    );
}

function appendNavItems(section, title, items, type, namespaceName) {
    const subtitle = document.createElement('h4');
    subtitle.className = 'nav-subtitle';

    // Add icon based on type
    const iconName = getNavIconForType(type);
    if (iconName) {
        const icon = document.createElement('i');
        icon.setAttribute('data-lucide', iconName);
        subtitle.appendChild(icon);
    }

    subtitle.appendChild(document.createTextNode(title));
    section.appendChild(subtitle);

    const list = document.createElement('ul');
    list.className = 'nav-list';

    items.forEach(item => {
        const li = document.createElement('li');
        li.className = `nav-item nav-item-${type}`;

        // Add icon
        const itemIcon = document.createElement('i');
        itemIcon.setAttribute('data-lucide', iconName);
        li.appendChild(itemIcon);

        const itemText = document.createElement('span');
        itemText.textContent = item.name;
        li.appendChild(itemText);

        li.addEventListener('click', () => {
            document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));
            li.classList.add('active');
            renderItem(item, type, namespaceName);
        });
        list.appendChild(li);
    });

    section.appendChild(list);
}

function appendGlobalsNavItem(section, title, functions, namespace) {
    const subtitle = document.createElement('h4');
    subtitle.className = 'nav-subtitle';

    // Add icon for globals
    const icon = document.createElement('i');
    icon.setAttribute('data-lucide', 'globe');
    subtitle.appendChild(icon);
    subtitle.appendChild(document.createTextNode(title));
    section.appendChild(subtitle);

    const list = document.createElement('ul');
    list.className = 'nav-list';

    const li = document.createElement('li');
    li.className = 'nav-item nav-item-function';

    // Add icon
    const itemIcon = document.createElement('i');
    itemIcon.setAttribute('data-lucide', 'globe');
    li.appendChild(itemIcon);

    const itemText = document.createElement('span');
    itemText.textContent = 'Global Functions';
    li.appendChild(itemText);

    li.addEventListener('click', () => {
        document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));
        li.classList.add('active');
        renderGlobals(functions, namespace.name);
    });
    list.appendChild(li);

    section.appendChild(list);
}

function showWelcomeMessage() {
    const content = document.getElementById('docContent');
    content.innerHTML = `
        <div class="placeholder-content">
            <h2>Documentation Loaded</h2>
            <p>Select an item from the navigation to view its documentation.</p>
        </div>
    `;
}

function renderItem(item, type, namespaceName) {
    const content = document.getElementById('docContent');
    content.innerHTML = '';

    const section = document.createElement('div');
    section.className = 'doc-section';

    // Header
    const header = document.createElement('div');
    header.className = 'doc-header';

    const title = document.createElement('h1');
    title.className = 'doc-title';
    title.textContent = item.name;
    header.appendChild(title);

    const typeLabel = document.createElement('span');
    typeLabel.className = 'doc-type ' + getTypeClass(type);
    typeLabel.textContent = type;
    header.appendChild(typeLabel);

    const nsLabel = document.createElement('span');
    nsLabel.className = 'doc-type ' + getTypeClass(namespaceName);
    nsLabel.style.marginLeft = '0.5rem';
    nsLabel.textContent = namespaceName;
    header.appendChild(nsLabel);

    section.appendChild(header);

    // Description
    if (item.description) {
        const desc = document.createElement('div');
        desc.className = 'description';
        desc.textContent = item.description;
        section.appendChild(desc);
    }

    // Type-specific rendering
    if (type === 'class') {
        renderClass(section, item);
    } else if (type === 'function') {
        renderFunction(section, item);
    } else if (type === 'field') {
        renderField(section, item);
    }

    content.appendChild(section);
    buildPageNavigation(item, type);
    initLucideIcons();
}

function renderGlobals(functions, namespaceName) {
    const content = document.getElementById('docContent');
    content.innerHTML = '';

    const section = document.createElement('div');
    section.className = 'doc-section';

    // Header
    const header = document.createElement('div');
    header.className = 'doc-header';

    const title = document.createElement('h1');
    title.className = 'doc-title';
    title.textContent = 'Global Functions';
    header.appendChild(title);

    const typeLabel = document.createElement('span');
    typeLabel.className = 'doc-type type-globals';
    typeLabel.textContent = 'globals';
    header.appendChild(typeLabel);

    const nsLabel = document.createElement('span');
    nsLabel.className = 'doc-type ' + getTypeClass(namespaceName);
    nsLabel.style.marginLeft = '0.5rem';
    nsLabel.textContent = namespaceName;
    header.appendChild(nsLabel);

    section.appendChild(header);

    // Description
    const desc = document.createElement('div');
    desc.className = 'description';
    desc.textContent = `Global functions in the ${namespaceName} namespace.`;
    section.appendChild(desc);

    // Separate static and non-static functions
    const staticFunctions = functions.filter(f => f.isStatic);
    const instanceFunctions = functions.filter(f => !f.isStatic);

    // Render static functions
    if (staticFunctions.length > 0) {
        const subsection = document.createElement('div');
        subsection.className = 'subsection';

        const subsectionTitle = document.createElement('h2');
        subsectionTitle.className = 'subsection-title';
        subsectionTitle.textContent = 'Static Functions';
        subsection.appendChild(subsectionTitle);

        const list = document.createElement('ul');
        list.className = 'item-list';

        staticFunctions.forEach(func => {
            const li = document.createElement('li');
            li.className = 'item';
            renderFunctionContent(li, func);
            list.appendChild(li);
        });

        subsection.appendChild(list);
        section.appendChild(subsection);
    }

    // Render instance functions
    if (instanceFunctions.length > 0) {
        const subsection = document.createElement('div');
        subsection.className = 'subsection';

        const subsectionTitle = document.createElement('h2');
        subsectionTitle.className = 'subsection-title';
        subsectionTitle.textContent = 'Instance Functions';
        subsection.appendChild(subsectionTitle);

        const list = document.createElement('ul');
        list.className = 'item-list';

        instanceFunctions.forEach(func => {
            const li = document.createElement('li');
            li.className = 'item';
            renderFunctionContent(li, func);
            list.appendChild(li);
        });

        subsection.appendChild(list);
        section.appendChild(subsection);
    }

    content.appendChild(section);
    buildPageNavigation(functions, 'globals');
    initLucideIcons();
}

function renderClass(section, classItem) {
    // Fields
    if (classItem.fields && classItem.fields.length > 0) {
        const subsection = document.createElement('div');
        subsection.className = 'subsection';

        const title = document.createElement('h2');
        title.className = 'subsection-title';
        title.textContent = 'Fields';
        subsection.appendChild(title);

        const list = document.createElement('ul');
        list.className = 'item-list';

        classItem.fields.forEach(field => {
            const li = document.createElement('li');
            li.className = 'item';

            const itemHeader = document.createElement('div');
            itemHeader.className = 'item-header';

            // Add icon
            const icon = document.createElement('i');
            icon.setAttribute('data-lucide', 'box');
            itemHeader.appendChild(icon);

            const name = document.createElement('span');
            name.className = 'item-name';
            name.textContent = field.name;
            itemHeader.appendChild(name);

            if (field.isStatic) {
                const badge = document.createElement('span');
                badge.className = 'item-badge static';
                badge.textContent = 'static';
                itemHeader.appendChild(badge);
            }

            li.appendChild(itemHeader);

            // Field signature
            const signatureWrapper = document.createElement('div');
            signatureWrapper.className = 'field-signature';

            const signatureContent = document.createElement('div');
            signatureContent.className = 'field-signature-content';

            const fieldName = document.createElement('span');
            fieldName.className = 'field-name';
            fieldName.textContent = field.name;
            signatureContent.appendChild(fieldName);

            const colon = document.createElement('span');
            colon.className = 'punctuation';
            colon.textContent = ': ';
            signatureContent.appendChild(colon);

            const fieldType = createColoredType(field.type);
            signatureContent.appendChild(fieldType);

            signatureWrapper.appendChild(signatureContent);

            // Copy button
            const copyBtn = document.createElement('button');
            copyBtn.className = 'copy-signature-btn';
            copyBtn.title = 'Copy field';
            const copyIcon = document.createElement('i');
            copyIcon.setAttribute('data-lucide', 'copy');
            copyBtn.appendChild(copyIcon);
            copyBtn.appendChild(document.createTextNode('Copy'));

            const plainSignature = `${field.name}: ${field.type}`;

            copyBtn.addEventListener('click', () => {
                navigator.clipboard.writeText(plainSignature).then(() => {
                    copyBtn.classList.add('copied');
                    const checkIcon = document.createElement('i');
                    checkIcon.setAttribute('data-lucide', 'check');
                    copyBtn.innerHTML = '';
                    copyBtn.appendChild(checkIcon);
                    copyBtn.appendChild(document.createTextNode('Copied'));
                    initLucideIcons();

                    setTimeout(() => {
                        copyBtn.classList.remove('copied');
                        copyBtn.innerHTML = '';
                        const copyIcon = document.createElement('i');
                        copyIcon.setAttribute('data-lucide', 'copy');
                        copyBtn.appendChild(copyIcon);
                        copyBtn.appendChild(document.createTextNode('Copy'));
                        initLucideIcons();
                    }, 2000);
                });
            });

            signatureWrapper.appendChild(copyBtn);
            li.appendChild(signatureWrapper);

            if (field.description) {
                const desc = document.createElement('div');
                desc.className = 'item-description';
                desc.textContent = field.description;
                li.appendChild(desc);
            }

            list.appendChild(li);
        });

        subsection.appendChild(list);
        section.appendChild(subsection);
    }

    // Functions
    if (classItem.functions && classItem.functions.length > 0) {
        // Separate static and instance methods
        const staticFunctions = classItem.functions.filter(f => f.isStatic);
        const instanceFunctions = classItem.functions.filter(f => !f.isStatic);

        // Render static methods first
        if (staticFunctions.length > 0) {
            const subsection = document.createElement('div');
            subsection.className = 'subsection';

            const title = document.createElement('h2');
            title.className = 'subsection-title';
            title.textContent = 'Static Methods';
            subsection.appendChild(title);

            const list = document.createElement('ul');
            list.className = 'item-list';

            staticFunctions.forEach(func => {
                const li = document.createElement('li');
                li.className = 'item';
                renderFunctionContent(li, func);
                list.appendChild(li);
            });

            subsection.appendChild(list);
            section.appendChild(subsection);
        }

        // Render instance methods
        if (instanceFunctions.length > 0) {
            const subsection = document.createElement('div');
            subsection.className = 'subsection';

            const title = document.createElement('h2');
            title.className = 'subsection-title';
            title.textContent = 'Instance Methods';
            subsection.appendChild(title);

            const list = document.createElement('ul');
            list.className = 'item-list';

            instanceFunctions.forEach(func => {
                const li = document.createElement('li');
                li.className = 'item';
                renderFunctionContent(li, func);
                list.appendChild(li);
            });

            subsection.appendChild(list);
            section.appendChild(subsection);
        }
    }
}

function renderFunction(section, func) {
    const container = document.createElement('div');
    renderFunctionContent(container, func);
    section.appendChild(container);
}

function renderFunctionContent(container, func) {
    // Function header
    const itemHeader = document.createElement('div');
    itemHeader.className = 'item-header';

    // Add icon
    const icon = document.createElement('i');
    icon.setAttribute('data-lucide', 'zap');
    itemHeader.appendChild(icon);

    const name = document.createElement('span');
    name.className = 'item-name';
    name.textContent = func.name;
    itemHeader.appendChild(name);

    if (func.isStatic) {
        const badge = document.createElement('span');
        badge.className = 'item-badge static';
        badge.textContent = 'static';
        itemHeader.appendChild(badge);
    }

    container.appendChild(itemHeader);

    // Function signature
    const signatureWrapper = document.createElement('div');
    signatureWrapper.className = 'function-signature';

    const signatureContent = document.createElement('div');
    signatureContent.className = 'function-signature-content';

    // Build colored signature
    const keyword = document.createElement('span');
    keyword.className = 'keyword';
    keyword.textContent = 'function';
    signatureContent.appendChild(keyword);

    signatureContent.appendChild(document.createTextNode(' '));

    const funcName = document.createElement('span');
    funcName.className = 'function-name';
    funcName.textContent = func.name;
    signatureContent.appendChild(funcName);

    const openParen = document.createElement('span');
    openParen.className = 'punctuation';
    openParen.textContent = '(';
    signatureContent.appendChild(openParen);

    // Parameters
    func.parameters.forEach((p, index) => {
        if (index > 0) {
            const comma = document.createElement('span');
            comma.className = 'punctuation';
            comma.textContent = ', ';
            signatureContent.appendChild(comma);
        }

        const paramName = document.createElement('span');
        paramName.className = 'param-name';
        paramName.textContent = p.name;
        signatureContent.appendChild(paramName);

        const colon = document.createElement('span');
        colon.className = 'punctuation';
        colon.textContent = ': ';
        signatureContent.appendChild(colon);

        const paramType = createColoredType(p.type + (p.optional ? '?' : ''));
        signatureContent.appendChild(paramType);
    });

    const closeParen = document.createElement('span');
    closeParen.className = 'punctuation';
    closeParen.textContent = ')';
    signatureContent.appendChild(closeParen);

    const colon = document.createElement('span');
    colon.className = 'punctuation';
    colon.textContent = ': ';
    signatureContent.appendChild(colon);

    // Return type
    const returnType = document.createElement('span');
    returnType.className = 'return-type';
    const returns = func.returns.map(r => r.type).join(', ') || 'void';
    returnType.textContent = returns;
    signatureContent.appendChild(returnType);

    signatureWrapper.appendChild(signatureContent);

    // Copy button
    const copyBtn = document.createElement('button');
    copyBtn.className = 'copy-signature-btn';
    copyBtn.title = 'Copy signature';
    const copyIcon = document.createElement('i');
    copyIcon.setAttribute('data-lucide', 'copy');
    copyBtn.appendChild(copyIcon);
    copyBtn.appendChild(document.createTextNode('Copy'));

    const plainSignature = `function ${func.name}(${func.parameters.map(p =>
        `${p.name}: ${p.type}${p.optional ? '?' : ''}`
    ).join(', ')}): ${returns}`;

    copyBtn.addEventListener('click', () => {
        navigator.clipboard.writeText(plainSignature).then(() => {
            copyBtn.classList.add('copied');
            const checkIcon = document.createElement('i');
            checkIcon.setAttribute('data-lucide', 'check');
            copyBtn.innerHTML = '';
            copyBtn.appendChild(checkIcon);
            copyBtn.appendChild(document.createTextNode('Copied'));
            initLucideIcons();

            setTimeout(() => {
                copyBtn.classList.remove('copied');
                copyBtn.innerHTML = '';
                const copyIcon = document.createElement('i');
                copyIcon.setAttribute('data-lucide', 'copy');
                copyBtn.appendChild(copyIcon);
                copyBtn.appendChild(document.createTextNode('Copy'));
                initLucideIcons();
            }, 2000);
        });
    });

    signatureWrapper.appendChild(copyBtn);
    container.appendChild(signatureWrapper);

    if (func.description) {
        const desc = document.createElement('div');
        desc.className = 'item-description';
        desc.textContent = func.description;
        container.appendChild(desc);
    }

    // Parameters
    if (func.parameters && func.parameters.length > 0) {
        const paramsSection = document.createElement('div');
        paramsSection.className = 'item-section';

        const paramTitle = document.createElement('div');
        paramTitle.className = 'item-section-title';
        const paramIcon = document.createElement('i');
        paramIcon.setAttribute('data-lucide', 'arrow-right');
        paramTitle.appendChild(paramIcon);
        paramTitle.appendChild(document.createTextNode('Parameters'));
        paramsSection.appendChild(paramTitle);

        const paramList = document.createElement('ul');
        paramList.className = 'param-list';

        func.parameters.forEach(param => {
            const li = document.createElement('li');
            li.className = 'param-item';

            const paramHeader = document.createElement('div');
            paramHeader.className = 'param-header';

            const paramName = document.createElement('span');
            paramName.className = 'item-name';
            paramName.style.fontSize = '0.9rem';
            paramName.textContent = param.name;
            paramHeader.appendChild(paramName);

            const paramType = createTypeElement(param.type + (param.optional ? '?' : ''));
            paramHeader.appendChild(paramType);

            if (param.optional) {
                const badge = document.createElement('span');
                badge.className = 'item-badge optional';
                badge.textContent = 'optional';
                paramHeader.appendChild(badge);
            }

            li.appendChild(paramHeader);

            if (param.description) {
                const desc = document.createElement('div');
                desc.className = 'item-description';
                desc.textContent = param.description;
                li.appendChild(desc);
            }

            paramList.appendChild(li);
        });

        paramsSection.appendChild(paramList);
        container.appendChild(paramsSection);
    }

    // Returns
    if (func.returns && func.returns.length > 0) {
        const returnsSection = document.createElement('div');
        returnsSection.className = 'item-section';

        const returnTitle = document.createElement('div');
        returnTitle.className = 'item-section-title';
        const returnIcon = document.createElement('i');
        returnIcon.setAttribute('data-lucide', 'corner-down-left');
        returnTitle.appendChild(returnIcon);
        returnTitle.appendChild(document.createTextNode('Returns'));
        returnsSection.appendChild(returnTitle);

        const returnList = document.createElement('ul');
        returnList.className = 'return-list';

        func.returns.forEach(ret => {
            const li = document.createElement('li');
            li.className = 'return-item';

            const retHeader = document.createElement('div');
            retHeader.className = 'return-header';

            const retType = createTypeElement(ret.type);
            retHeader.appendChild(retType);
            li.appendChild(retHeader);

            if (ret.description) {
                const desc = document.createElement('div');
                desc.className = 'item-description';
                desc.textContent = ret.description;
                li.appendChild(desc);
            }

            returnList.appendChild(li);
        });

        returnsSection.appendChild(returnList);
        container.appendChild(returnsSection);
    }
}

function renderField(section, field) {
    const container = document.createElement('div');

    const itemHeader = document.createElement('div');
    itemHeader.className = 'item-header';

    // Add icon
    const icon = document.createElement('i');
    icon.setAttribute('data-lucide', 'box');
    itemHeader.appendChild(icon);

    const name = document.createElement('span');
    name.className = 'item-name';
    name.textContent = field.name;
    itemHeader.appendChild(name);

    if (field.isStatic) {
        const badge = document.createElement('span');
        badge.className = 'item-badge static';
        badge.textContent = 'static';
        itemHeader.appendChild(badge);
    }

    container.appendChild(itemHeader);

    // Field signature
    const signatureWrapper = document.createElement('div');
    signatureWrapper.className = 'field-signature';

    const signatureContent = document.createElement('div');
    signatureContent.className = 'field-signature-content';

    const fieldName = document.createElement('span');
    fieldName.className = 'field-name';
    fieldName.textContent = field.name;
    signatureContent.appendChild(fieldName);

    const colon = document.createElement('span');
    colon.className = 'punctuation';
    colon.textContent = ': ';
    signatureContent.appendChild(colon);

    const fieldType = createColoredType(field.type);
    signatureContent.appendChild(fieldType);

    signatureWrapper.appendChild(signatureContent);

    // Copy button
    const copyBtn = document.createElement('button');
    copyBtn.className = 'copy-signature-btn';
    copyBtn.title = 'Copy field';
    const copyIcon = document.createElement('i');
    copyIcon.setAttribute('data-lucide', 'copy');
    copyBtn.appendChild(copyIcon);
    copyBtn.appendChild(document.createTextNode('Copy'));

    const plainSignature = `${field.name}: ${field.type}`;

    copyBtn.addEventListener('click', () => {
        navigator.clipboard.writeText(plainSignature).then(() => {
            copyBtn.classList.add('copied');
            const checkIcon = document.createElement('i');
            checkIcon.setAttribute('data-lucide', 'check');
            copyBtn.innerHTML = '';
            copyBtn.appendChild(checkIcon);
            copyBtn.appendChild(document.createTextNode('Copied'));
            initLucideIcons();

            setTimeout(() => {
                copyBtn.classList.remove('copied');
                copyBtn.innerHTML = '';
                const copyIcon = document.createElement('i');
                copyIcon.setAttribute('data-lucide', 'copy');
                copyBtn.appendChild(copyIcon);
                copyBtn.appendChild(document.createTextNode('Copy'));
                initLucideIcons();
            }, 2000);
        });
    });

    signatureWrapper.appendChild(copyBtn);
    container.appendChild(signatureWrapper);

    if (field.description) {
        const desc = document.createElement('div');
        desc.className = 'item-description';
        desc.textContent = field.description;
        container.appendChild(desc);
    }

    section.appendChild(container);
}

// Get color for type
function getTypeColor(typeName) {
    const type = typeName.toLowerCase().replace(/\?$/, '');
    const colorMap = {
        'string': 'var(--type-string)',
        'number': 'var(--type-number)',
        'boolean': 'var(--type-boolean)',
        'bool': 'var(--type-boolean)',
        'table': 'var(--type-table)',
        'function': 'var(--type-function)',
        'userdata': 'var(--type-userdata)',
        'nil': 'var(--type-nil)',
        'any': 'var(--type-any)',
        'void': 'var(--type-nil)'
    };
    return colorMap[type] || 'var(--type-userdata)';
}

// Create colored type span for function signatures
function createColoredType(typeString) {
    const span = document.createElement('span');
    span.style.color = getTypeColor(typeString);
    span.textContent = typeString;
    return span;
}

// Helper function to create a clickable type element
function createTypeElement(typeString) {
    const container = document.createElement('span');
    container.className = 'item-type';

    // Parse the type string to handle union types and optional markers
    const types = parseTypeString(typeString);

    types.forEach((typePart, index) => {
        const trimmedName = typePart.name.trim();

        // Handle separators
        if (trimmedName === '|' || trimmedName === '&') {
            const sep = document.createElement('span');
            sep.className = 'type-separator';
            sep.textContent = ' ' + trimmedName + ' ';
            container.appendChild(sep);
            return;
        }

        if (trimmedName === '<' || trimmedName === '>' || trimmedName === ',') {
            const sep = document.createElement('span');
            sep.className = 'type-separator';
            sep.textContent = trimmedName;
            container.appendChild(sep);
            return;
        }

        // Create type token
        const typeToken = document.createElement('span');
        typeToken.className = 'type-token';
        typeToken.textContent = trimmedName;

        // Check if this type is a registered class
        const cleanType = trimmedName.replace(/\?$/, ''); // Remove optional marker at end
        if (classRegistry.has(cleanType)) {
            typeToken.classList.add('clickable-type');
            typeToken.dataset.classType = cleanType;
            typeToken.style.cssText = 'cursor: pointer; text-decoration: underline dotted;';
            typeToken.style.color = 'var(--accent)';
            typeToken.title = 'Click to view ' + cleanType;

            typeToken.addEventListener('click', (e) => {
                e.stopPropagation();
                e.preventDefault();
                const classInfo = classRegistry.get(cleanType);
                if (classInfo) {
                    // Clear active navigation
                    document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));
                    renderItem(classInfo.class, 'class', classInfo.namespace);
                }
            });
        } else {
            // Apply color based on type
            typeToken.style.color = getTypeColor(cleanType);
        }

        container.appendChild(typeToken);
    });

    return container;
}

// Parse type string into parts (handling union types like "string|number")
function parseTypeString(typeString) {
    const parts = [];
    // Split by | and & but also handle generic types like table<string, XCore.Player>
    const tokens = typeString.split(/(\||&|<|>|,)/);

    for (let i = 0; i < tokens.length; i++) {
        const token = tokens[i].trim();
        if (!token) continue;

        if (token === '|' || token === '&') {
            parts.push({ name: ' ' + token + ' ', separator: '' });
        } else if (token === '<' || token === '>' || token === ',') {
            parts.push({ name: token, separator: '' });
        } else {
            parts.push({ name: token, separator: '' });
        }
    }

    return parts;
}

// Theme toggle: persist preference in localStorage and apply .dark on root
function applyTheme(theme) {
    const root = document.documentElement;
    if (theme === 'dark') {
        root.classList.add('dark');
        const btn = document.getElementById('themeToggle');
        if (btn) btn.textContent = '☀️';
    } else {
        root.classList.remove('dark');
        const btn = document.getElementById('themeToggle');
        if (btn) btn.textContent = '🌙';
    }
    try { localStorage.setItem('theme', theme); } catch (e) { /* ignore */ }
}

function initThemeToggle() {
    const btn = document.getElementById('themeToggle');
    if (!btn) return;

    // Determine initial theme: stored preference, then system preference, then default light
    let theme = null;
    try { theme = localStorage.getItem('theme'); } catch (e) { theme = null; }

    if (!theme) {
        const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
        theme = prefersDark ? 'dark' : 'light';
    }

    applyTheme(theme);

    btn.addEventListener('click', () => {
        const current = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
        const next = current === 'dark' ? 'light' : 'dark';
        applyTheme(next);
    });
}

// Get icon name for navigation item type
function getNavIconForType(type) {
    const iconMap = {
        'class': 'package',
        'function': 'zap',
        'field': 'box'
    };
    return iconMap[type] || 'file';
}

// Get CSS class for type tag coloring
function getTypeClass(type) {
    if (!type) return '';

    const typeLower = type.toLowerCase();

    // Map type names to CSS classes
    const typeMap = {
        'class': 'type-class',
        'function': 'type-function',
        'field': 'type-field',
        'globals': 'type-globals',
        'server': 'type-server',
        'client': 'type-client',
        'shared': 'type-shared',
        'namespace': 'type-namespace'
    };

    return typeMap[typeLower] || 'type-namespace';
}

// Initialize Lucide icons
function initLucideIcons() {
    if (typeof lucide !== 'undefined' && lucide.createIcons) {
        lucide.createIcons();
    }
}

// Toggle sidebar right
function initSidebarToggle() {
    const sidebar = document.getElementById('sidebarRight');

    if (!sidebar) return;

    let isHovering = false;
    let isPinned = false;

    // Open on hover
    sidebar.addEventListener('mouseenter', () => {
        isHovering = true;
        if (!isPinned) {
            sidebar.classList.remove('collapsed');
            updateSidebarIcon(sidebar, false);
        }
    });

    // Close on leave (if not pinned)
    sidebar.addEventListener('mouseleave', () => {
        isHovering = false;
        if (!isPinned) {
            setTimeout(() => {
                if (!isHovering && !isPinned) {
                    sidebar.classList.add('collapsed');
                    updateSidebarIcon(sidebar, true);
                }
            }, 300);
        }
    });

    // Toggle pin on button click
    const toggleBtn = document.getElementById('toggleSidebarRight');
    if (toggleBtn) {
        toggleBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            isPinned = !isPinned;

            if (isPinned) {
                sidebar.classList.remove('collapsed');
                sidebar.classList.add('pinned');
                updateSidebarIcon(sidebar, false);
            } else {
                sidebar.classList.remove('pinned');
                if (!isHovering) {
                    sidebar.classList.add('collapsed');
                    updateSidebarIcon(sidebar, true);
                }
            }
        });
    }
}

function updateSidebarIcon(sidebar, isCollapsed) {
    const icon = sidebar.querySelector('.sidebar-toggle-btn i');
    if (icon) {
        icon.setAttribute('data-lucide', isCollapsed ? 'panel-right-open' : 'panel-right-close');
        initLucideIcons();
    }
}

// Build page navigation tree
function buildPageNavigation(item, type) {
    const nav = document.getElementById('pageNavigation');
    if (!nav) return;

    nav.innerHTML = '';

    if (type === 'class') {
        // Fields section
        if (item.fields && item.fields.length > 0) {
            const section = createPageNavSection('Fields', 'box', item.fields, 'field');
            nav.appendChild(section);
        }

        // Static Methods section
        const staticMethods = item.functions ? item.functions.filter(f => f.isStatic) : [];
        if (staticMethods.length > 0) {
            const section = createPageNavSection('Static Methods', 'zap', staticMethods, 'function');
            nav.appendChild(section);
        }

        // Instance Methods section
        const instanceMethods = item.functions ? item.functions.filter(f => !f.isStatic) : [];
        if (instanceMethods.length > 0) {
            const section = createPageNavSection('Instance Methods', 'zap', instanceMethods, 'function');
            nav.appendChild(section);
        }
    } else if (type === 'globals') {
        // For globals, split by static/instance
        const staticFunctions = item.filter(f => f.isStatic);
        const instanceFunctions = item.filter(f => !f.isStatic);

        if (staticFunctions.length > 0) {
            const section = createPageNavSection('Static Functions', 'zap', staticFunctions, 'function');
            nav.appendChild(section);
        }

        if (instanceFunctions.length > 0) {
            const section = createPageNavSection('Instance Functions', 'zap', instanceFunctions, 'function');
            nav.appendChild(section);
        }
    }

    initLucideIcons();
}

function createPageNavSection(title, iconName, items, type) {
    const section = document.createElement('div');
    section.className = 'page-nav-section';

    const titleEl = document.createElement('div');
    titleEl.className = 'page-nav-title';

    const icon = document.createElement('i');
    icon.setAttribute('data-lucide', iconName);
    titleEl.appendChild(icon);
    titleEl.appendChild(document.createTextNode(title));

    section.appendChild(titleEl);

    const list = document.createElement('ul');
    list.className = 'page-nav-list';

    items.forEach(item => {
        const li = document.createElement('li');
        li.className = 'page-nav-item';
        li.textContent = item.name;
        li.dataset.itemName = item.name;

        li.addEventListener('click', () => {
            // Scroll to item
            const itemElements = document.querySelectorAll('.item');
            itemElements.forEach(el => {
                const nameEl = el.querySelector('.item-name');
                if (nameEl && nameEl.textContent === item.name) {
                    el.scrollIntoView({ behavior: 'smooth', block: 'start' });

                    // Highlight briefly
                    el.style.outline = '2px solid var(--accent)';
                    setTimeout(() => {
                        el.style.outline = '';
                    }, 2000);
                }
            });

            // Update active state
            document.querySelectorAll('.page-nav-item').forEach(el => el.classList.remove('active'));
            li.classList.add('active');
        });

        list.appendChild(li);
    });

    section.appendChild(list);
    return section;
}

// Initialize theme when DOM content is ready
document.addEventListener('DOMContentLoaded', () => {
    initThemeToggle();
    initLucideIcons();
    initSidebarToggle();

    // Initialize header icons
    setTimeout(() => {
        initLucideIcons();
    }, 100);
});
