/*
 * Droppable List
 * Renders Draggable group admin cards
 *
 */

import PropTypes from 'prop-types';
import React from 'react';

import { Grid } from '@material-ui/core';
import { intlShape } from 'react-intl';

import { DroppableList } from 'components/Shared/DragAndDrop/DroppableLocations/DroppableList';
import DraggableGroupAdminCard from '../DraggableGroupAdminCard';


export function DroppableGroupList(props) {
  const renderCard = (card, index, moveCard) => (
    <Grid item key={card.id} xs={12}>
      <DraggableGroupAdminCard
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
    <DroppableList
      items={props.items}
      positions={props.positions}
      renderCard={renderCard}
      classes={props.classes}
      draggable={props.draggable}
      save={props.save}
      updateOrderAction={props.updateGroupPositionBegin}
      currentPage={props.currentPage}
      importAction={props.importAction}
      rowsPerPage={props.rowsPerPage}
      intl={props.intl}
    />
  );
}

DroppableGroupList.propTypes = {
  items: PropTypes.array,
  classes: PropTypes.object,
  save: PropTypes.bool,
  updateGroupPositionBegin: PropTypes.func,
  currentPage: PropTypes.number,
  importAction: PropTypes.func,
  deleteGroupBegin: PropTypes.func,
  draggable: PropTypes.bool,
  rowsPerPage: PropTypes.number,
  positions: PropTypes.array,
  intl: intlShape.isRequired,
};