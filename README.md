# Fluxo de Git

## Diagrama

```text
                                    PRODUÇÃO
                                       ▲
                                       │
                            PR (Rebase/Fast-forward)
                                       │
                                  ┌────┴────┐
                                  │  main   │
                                  └────▲────┘
                                       │
                            PR (Rebase/Fast-forward)
                                       │
                                 ┌─────┴─────┐
                                 │  hotfix   │
                                 └─────▲─────┘
                                       │
                            PR (Rebase/Fast-forward)
                                       │
                              ┌────────┴────────┐                     ┌──────────────┐
                              │    develop      │ ─────via Action ─── │   Approval   │  
                              └────────▲────────┘                     └──────────────┘
                                       │
         ┌─────────────────────────────┼─────────────────────────────┐
         │                             │                             │
         │                             │                             │
┌────────┴────────┐          ┌─────────┴────────┐          ┌─────────┴────────┐
│      dev-a      │          │      dev-b       │          │      dev-c       │
├─────────────────┤          ├──────────────────┤          ├──────────────────┤
│ feat            │          │ feat             │          │ feat             │
│ fix             │          │ fix              │          │ refactor         │
│ refactor        │          │ style            │          │ fix              │
│ vários commits  │          │ vários commits   │          │ vários commits   │
└────────▲────────┘          └────────▲─────────┘          └────────▲─────────┘
         │                             │                             │
         └────────────── PR (Squash and Merge) ──────────────────────┘
```

---

# Fluxo do Desenvolvedor

## 1. Atualizar a branch

```bash
git checkout develop
git pull origin develop

git checkout dev-b
git rebase develop
```

---

## 2. Desenvolver normalmente

```bash
git add .
git commit -m "feat(catalogo): adiciona URLs"

git add .
git commit -m "fix(catalogo): corrige filtros"

git add .
git commit -m "refactor(catalogo): remove duplicação"

git push origin dev-b
```

Faça quantos commits forem necessários.

---

## 3. Abrir Pull Request

```
Origem : dev-b
Destino: develop
```

Selecionar:

```
✅ Squash and Merge
```

Mensagem final:

```
feat(catalogo): implementa catálogo
```

Na `develop` ficará apenas:

```
● feat(catalogo): implementa catálogo
```

---

# Atualizando as outras branches

Após o merge do PR, os outros desenvolvedores executam:

```bash
git checkout dev-c

git fetch origin

git rebase origin/develop

git push --force-with-lease
```

A branch ficará sincronizada com a `develop`.

---

# Fluxo entre branches

| Origem | Destino | Merge |
|---------|----------|-----------------------|
| dev-* | develop | Squash and Merge |
| develop | approval | Rebase/Fast-forward |
| approval | hotfix | Rebase/Fast-forward |
| hotfix | main | Rebase/Fast-forward |

---

# Hotfix

Criar uma branch:

```bash
git checkout hotfix

git checkout -b hotfix/corrige-pdf
```

Corrigir:

```bash
git add .

git commit -m "fix(pdf): corrige renderização"

git push origin hotfix/corrige-pdf
```

Abrir PR:

```
hotfix/corrige-pdf
        ↓
      hotfix
```

Após aprovado:

```
hotfix
    ↓
main

hotfix
    ↓
develop
```

Assim a correção volta para o fluxo de desenvolvimento.

---

# Rollback

Visualizar histórico:

```bash
git log --oneline
```

Exemplo:

```
abc123 feat(catalogo): implementa catálogo
def456 feat(login): autenticação
ghi789 fix(pdf): corrige logo
```

Reverter um commit:

```bash
git revert abc123
```

Enviar:

```bash
git push origin main
```

Será criado:

```
● feat(login): autenticação
● feat(catalogo): implementa catálogo
● fix(pdf): corrige logo
● Revert "feat(catalogo): implementa catálogo"
```

---

# Convenção de commits

```
feat(...)
fix(...)
refactor(...)
perf(...)
docs(...)
style(...)
test(...)
build(...)
ci(...)
chore(...)
```

Exemplos:

```text
feat(pedido): adiciona conferência de estoque

fix(pdf): corrige renderização do logo

refactor(api): remove consultas duplicadas

perf(sql): otimiza FN_ARRAY

docs(ci): atualiza workflow

ci(actions): adiciona sincronização automática
```

---

# Resultado esperado

Histórico da `develop`:

```text
● feat(login): autenticação
● feat(catalogo): implementa catálogo
● fix(pdf): corrige renderização
● feat(pedido): conferência de estoque
● refactor(api): otimiza consultas
```

Histórico da `main`:

```text
● feat(login): autenticação
● feat(catalogo): implementa catálogo
● fix(pdf): corrige renderização
● feat(pedido): conferência de estoque
● refactor(api): otimiza consultas
```

Sem commits de merge, histórico linear, um commit por funcionalidade e rollback simples com `git revert`.
