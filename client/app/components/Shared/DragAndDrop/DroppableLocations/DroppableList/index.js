/*
 * Droppable List
 * A list of draggable cards
 *
 */

import PropTypes from 'prop-types';
import { DndProvider, useDrop } from 'react-dnd';
import Backend from 'react-dnd-html5-backend';
import React, { useState, useCallback } from 'react';
import update from 'immutability-helper';
import DraggableCard from '../../DraggableItems/DraggableCard';

export function DroppableList(props) {
  const [cards, setCards] = useState([
    {
      id: 1,
      text: 'Write a cool JS library',
    },
    {
      id: 2,
      text: 'Make it generic enough',
    },
    {
      id: 3,
      text: 'Write README',
    },
    {
      id: 4,
      text: 'Create some examples',
    },
    {
      id: 5,
      text:
        'Spam in Twitter and IRC t o promote it (note that this element is taller than the others)',
    },
    {
      id: 6,
      text: '???',
    },
    {
      id: 7,
      text: 'PROFIT',
    },
  ]);


  const moveCard = useCallback(
    (dragIndex, hoverIndex) => {
      const dragCard = cards[dragIndex];
      setCards(
        update(cards, {
          $splice: [
            [dragIndex, 1],
            [hoverIndex, 0, dragCard],
          ],
        }),
      );
    },
    [cards],
  );

  const renderCard = (card, index) => (
    <DraggableCard
      key={card.id}
      index={index}
      id={card.id}
      text={card.text}
      moveCard={moveCard}
    />
  );

  return (
    <DndProvider backend={Backend}>
      {cards.map((card, i) => renderCard(card, i))}
    </DndProvider>
  );
}
