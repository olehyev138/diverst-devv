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
import produce from 'immer';
import DraggableCard from '../../DraggableItems/DraggableCard';

export function DroppableList(props) {
  const [cards, setCards] = useState(Object.values(props.list));
  const moveCard = useCallback(
    (dragIndex, hoverIndex) => {
      const dragCard = cards[dragIndex];
      const tempCard = [...cards];

      tempCard.splice(dragIndex, 1);
      tempCard.splice(hoverIndex, 0, dragCard);
      setCards(
        tempCard
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
      group={card}
      classes={props.classes}
      draggable={props.draggable}
    />
  );
  return (
    <DndProvider backend={Backend}>
      {cards.map((card, i) => renderCard(card, i))}
    </DndProvider>
  );
}

DroppableList.propTypes = {
  list: PropTypes.object,
  classes: PropTypes.object,
};
