document.addEventListener('DOMContentLoaded', () => {
    const board = document.getElementById('board');
    let draggedElement = null;

    // Component data to define behavior
    const components = {
        battery: { type: 'battery', power: 1, connectedTo: [] },
        led: { type: 'led', powered: false, connectedTo: [] },
        cable: { type: 'cable', connectedTo: [] },
        switch: { type: 'switch', state: 'off', connectedTo: [] } // Switch component with on/off state
    };

    // Allow draggable components to be dragged
    document.querySelectorAll('.component').forEach(component => {
        component.addEventListener('dragstart', (e) => {
            draggedElement = e.target;
            setTimeout(() => {
                e.target.style.display = 'none'; // Hide the element during dragging
            }, 0);
        });

        component.addEventListener('dragend', (e) => {
            setTimeout(() => {
                e.target.style.display = 'block'; // Show the element after dragging
                draggedElement = null;
            }, 0);
        });
    });

    // Allow dropping on the circuit board
    board.addEventListener('dragover', (e) => {
        e.preventDefault(); // Must prevent default to allow drop
    });

    board.addEventListener('drop', (e) => {
        e.preventDefault();
        if (draggedElement) {
            // Check if the dragged element is from the original component palette
            if (!draggedElement.classList.contains('placed')) {
                const clonedElement = draggedElement.cloneNode(true);
                clonedElement.style.display = 'block'; // Ensure the cloned element is visible
                clonedElement.style.position = 'relative'; // Align with grid
                clonedElement.style.width = '100%';
                clonedElement.style.height = '100%';

                // Calculate the closest grid cell for snapping
                const gridSize = board.offsetWidth / 10; // Assuming a 10x10 grid
                const x = Math.floor((e.clientX - board.getBoundingClientRect().left) / gridSize);
                const y = Math.floor((e.clientY - board.getBoundingClientRect().top) / gridSize);

                // Set the grid position for the cloned element using inline styles
                clonedElement.style.gridColumnStart = x + 1;
                clonedElement.style.gridRowStart = y + 1;

                // Append the cloned element to the board
                board.appendChild(clonedElement);

                // Assign component type and grid position
                clonedElement.classList.add('placed');
                const componentType = clonedElement.dataset.type;
                clonedElement.componentData = { ...components[componentType], element: clonedElement, gridX: x, gridY: y };

                // Disable dragging on cloned element
                clonedElement.setAttribute('draggable', 'false');

                // Add a double-click event listener to delete the element
                clonedElement.addEventListener('dblclick', () => {
                    board.removeChild(clonedElement); // Remove the element from the board
                    updateConnections(); // Update circuit connections after deletion
                });

                // Add a click event listener to toggle the switch state
                if (componentType === 'switch') {
                    clonedElement.addEventListener('click', () => {
                        toggleSwitch(clonedElement);
                    });
                }

                updateConnections(); // Update connections after placing a new element
            }
        }
    });

    // Function to update the state of components based on grid-based adjacency
    function updateConnections() {
        const allComponents = Array.from(board.querySelectorAll('.placed'));
        allComponents.forEach(component => {
            component.componentData.connectedTo = []; // Reset connections
        });

        // Check for adjacency and make connections
        allComponents.forEach(component => {
            const { gridX, gridY, type } = component.componentData;
            if (type === 'cable' || type === 'battery' || type === 'led' || type === 'switch') {
                // Check all 4 possible adjacent cells (up, down, left, right)
                const adjacentComponents = findAdjacentComponents(gridX, gridY, allComponents);

                adjacentComponents.forEach(adjComponent => {
                    component.componentData.connectedTo.push(adjComponent);
                    adjComponent.componentData.connectedTo.push(component);
                });
            }
        });

        // Update LED states based on connected paths to a battery
        allComponents.forEach(component => {
            if (component.componentData.type === 'led') {
                const isPowered = isComponentPowered(component);
                component.style.backgroundColor = isPowered ? 'yellow' : ''; // Turn LED "on" if powered
            }
        });
    }

    // Function to find adjacent components based on grid positions
    function findAdjacentComponents(x, y, allComponents) {
        const adjacent = [];
        allComponents.forEach(component => {
            const { gridX, gridY } = component.componentData;
            if ((gridX === x && gridY === y - 1) ||  // Up
                (gridX === x && gridY === y + 1) ||  // Down
                (gridX === x - 1 && gridY === y) ||  // Left
                (gridX === x + 1 && gridY === y)) {  // Right
                adjacent.push(component);
            }
        });
        return adjacent;
    }

    // Function to determine if a component is powered by a battery
    function isComponentPowered(component) {
        const visited = new Set();
        const toVisit = [component];

        while (toVisit.length > 0) {
            const current = toVisit.pop();
            if (visited.has(current)) continue;
            visited.add(current);

            if (current.componentData.type === 'battery') {
                return true; // Found a power source
            }

            if (current.componentData.type === 'switch' && current.componentData.state === 'off') {
                continue; // Skip paths with an "off" switch
            }

            current.componentData.connectedTo.forEach(conn => {
                if (!visited.has(conn)) {
                    toVisit.push(conn);
                }
            });
        }

        return false;
    }

    // Function to toggle the state of a switch component
    function toggleSwitch(switchComponent) {
        const currentState = switchComponent.componentData.state;
        const newState = currentState === 'off' ? 'on' : 'off';
        switchComponent.componentData.state = newState;

        // Update the visual representation of the switch (optional)
        switchComponent.style.backgroundColor = newState === 'on' ? 'green' : 'gray';

        // Update circuit connections after toggling the switch
        updateConnections();
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const openInstructionsButton = document.getElementById('openInstructions');
    const instructionsModal = document.getElementById('instructionsModal');
    const closeInstructionsButton = document.getElementById('closeInstructions');

    // Open the modal when the button is clicked
    openInstructionsButton.addEventListener('click', () => {
        instructionsModal.style.display = 'block';
    });

    // Close the modal when the close button is clicked
    closeInstructionsButton.addEventListener('click', () => {
        instructionsModal.style.display = 'none';
    });

    // Close the modal when clicking outside the modal content
    window.addEventListener('click', (event) => {
        if (event.target === instructionsModal) {
            instructionsModal.style.display = 'none';
        }
    });
});
