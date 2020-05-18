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
import DragDropContext from '../../DragDropContext';

export function DroppableList(props) {
  const [cards, setCards] = useState(Object.values(props.list));
  const moveCard = useCallback(
    (dragIndex, hoverIndex) => {
      const dragCard = cards[dragIndex];
      const tempCard = [...cards];

      tempCard.splice(dragIndex, 1);
      tempCard.splice(hoverIndex, 0, dragCard);

      console.log(dragIndex);
      console.log(hoverIndex);
      setCards(
        tempCard
      );
    },

    [cards],
  );

  if(props.save){
    //Increment card positions based on position in the array
    //
    const abc = 0/0;
    cards.map((c,index)=>{
      //Card has moved back
      if(c.position > index)
        c.position = c.position - (cards.length - index - 1);

      //Card has moved forward
      //Card has not changed
      //if(c.position==index)

    })
    props.updateGroupPositionBegin(cards);
  }

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
    <DragDropContext>
      {cards.map((card, i) => renderCard(card, i))}
    </DragDropContext>
  );
}

DroppableList.propTypes = {
  list: PropTypes.object,
  classes: PropTypes.object,
  save: PropTypes.bool,
  updateGroupPositionBegin: PropTypes.func,
};
