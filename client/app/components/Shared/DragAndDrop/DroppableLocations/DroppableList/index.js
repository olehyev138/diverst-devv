/*
 * Droppable List
 * A list of draggable cards
 *
 */

import PropTypes from 'prop-types';

import React, { useState, useCallback, useEffect } from 'react';

import DraggableCard from '../../DraggableItems/DraggableCard';
import DragDropContext from '../../DragDropContext';
import { Grid } from '@material-ui/core';
import { intlShape } from 'react-intl';

export function DroppableList(props) {
  const [cards, setCards] = useState(Object.values(props.items));
  const total = cards.length;

  useEffect(() => {
    setCards(props.items);
  }, [props.items]);

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

  if (props.save)
    cards.map((card, index) => {
      card.position = index + props.currentPage * cards.length;
      props.updateGroupPositionBegin(card);
    });


  const renderCard = (card, index) => (
    <Grid item key={card.id} xs={12}>
      <DraggableCard
        key={card.id}
        index={index}
        id={card.id}
        text={card.text}
        moveCard={moveCard}
        group={card}
        classes={props.classes}
        draggable={props.draggable}
        importAction={props.importAction}
        deleteGroupBegin={props.deleteGroupBegin}
        intl={props.intl}
      />
    </Grid>
  );


  return (
    <DragDropContext>
      <Grid container spacing={3} justify='flex-end'>
        {cards.map((card, i) => renderCard(card, i))}
      </Grid>
    </DragDropContext>
  );
}

DroppableList.propTypes = {
  items: PropTypes.array,
  classes: PropTypes.object,
  save: PropTypes.bool,
  updateGroupPositionBegin: PropTypes.func,
  currentPage: PropTypes.number,
  importAction: PropTypes.func,
  deleteGroupBegin: PropTypes.func,
  draggable: PropTypes.bool,
  intl: intlShape,
};
