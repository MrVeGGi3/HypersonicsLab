# 🔬 HYPERSONICS LAB


Um ambiente de simulação em tempo real desenvolvido na **Godot Engine** para validar conceitos de física avançada, engenharia aeroespacial e termodinâmica de fluidos.

O objetivo deste laboratório é criar uma biblioteca de componentes físicos reutilizáveis que permitam a prototipagem rápida de sistemas complexos (como motores, aerodinâmica e veículos) com precisão matemática.

---

## 🧪 Módulo Atual: Propulsão Hipersônica (Scramjet/Ramjet)

<img width="1625" height="706" alt="ScramjetCFD1D" src="https://github.com/user-attachments/assets/78a2f09f-dd66-4526-ae6f-2c83981c3936" />

O primeiro grande experimento do laboratório foca na simulação de ciclos termodinâmicos para motores a jato sem partes móveis.

### O Desafio
Simular o comportamento de um motor Scramjet do zero, calculando as propriedades do fluxo de ar passo a passo enquanto ele atravessa os componentes do motor.

### Core Physics Implementada
Este módulo valida a interação entre três fenômenos fundamentais da dinâmica dos gases:

1.  **Fanno Flow (Atrito):** Simulação de perdas de carga e bloqueio sônico em dutos isoladores.
2.  **Rayleigh Flow (Combustão):** Adição de calor em fluxo compressível e análise de choque térmico.
3.  **Escoamento Isentrópico (Bocal):** Expansão de gases e geração de empuxo com bocal de geometria variável.

> **Destaque Técnico:** O solver implementado é híbrido, utilizando métodos de Newton-Raphson para precisão e Bisseção para estabilidade numérica, capaz de lidar com a transição entre regimes subsônicos e supersônicos dinamicamente.

---

## 🏗️ Arquitetura do Laboratório

O projeto foi desenhado com modularidade em mente, permitindo que as classes de física sejam reutilizadas em futuros experimentos:

* **`AtmoProperties`:** Singleton global para cálculos de atmosfera padrão e propriedades de gases reais.
* **`FluidSolvers`:** Bibliotecas de algoritmos numéricos (Newton-Raphson, Derivadas) na pasta "Calculators" desacopladas da lógica do jogo.
* **Componentes Modulares:** `RayleighFlow` e `FannoFlow` são Nodes que podem ser acoplados a qualquer objeto no laboratório, não apenas motores.

## 🛠️ Tech Stack & Ferramentas

* **Engine:** Godot 4.x (GDScript Tipado)
* **Física:** Dinâmica de Fluidos Compressíveis 1D (CFD-lite)
* **Integração Futura:** Preparado para VR/XR (Meta Quest) 

## 🚀 Roadmap do Laboratório

- [x] **Fase 1:** Core de Termodinâmica (Scramjet)
- [ ] **Fase 2:** Integração de Trajetória e Controle
- [ ] **Fase 3:** Visualização de Dados em Tempo Real (Gráficos In-Game)
- [ ] **Fase 4:** Ambiente de Testes em Realidade Virtual

---
*Este repositório é um "work in progress" constante de estudos avançados em engenharia e simulação.*
