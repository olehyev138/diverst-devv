/**
 *
 * CheckboxField
 *
 */

import React from 'react';
import PropTypes from 'prop-types';

import dig from 'object-dig';
import { List, ListItem, Typography, ListItemIcon } from '@material-ui/core';
import ArrowRightIcon from '@material-ui/icons/ArrowRight';

const CustomCheckbox = (props) => {
  const { classes } = props;

  const fieldDatum = dig(props, 'fieldDatum');
  const fieldDatumIndex = dig(props, 'fieldDatumIndex');

  return (
    <div className={classes.cell}>
      <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
        {fieldDatum.field.title}
      </Typography>
      <Typography color='secondary' component='h2'>
        {fieldDatum.data.length > 0 && (
          <List>
            {fieldDatum.data.map((datum, i) => (
              // eslint-disable-next-line react/no-array-index-key
              <ListItem dense key={`fieldData${fieldDatum.id}-${i}`}>
                <ArrowRightIcon fontSize='small' />
                {`${datum.value}`}
              </ListItem>
            ))}
          </List>
        )}
        {fieldDatum.data.length <= 0 && (
          <List>
            <ListItem dense>
              (Nothing Selected)
            </ListItem>
          </List>
        )}
      </Typography>
    </div>
  );
};

CustomCheckbox.propTypes = {
  classes: PropTypes.object,
  fieldDatum: PropTypes.shape({
    data: PropTypes.array,
  }),
  fieldDatumIndex: PropTypes.number,
  dataLocation: PropTypes.string,
};

export default CustomCheckbox;
