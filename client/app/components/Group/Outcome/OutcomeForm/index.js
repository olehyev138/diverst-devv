/**
 *
 * Outcome Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import { FormattedMessage } from 'react-intl';
import { Field, Formik, Form, FieldArray } from 'formik';
import {
  withStyles, Button, Card, CardActions, CardContent, TextField, Divider, Typography, Paper, Box, Grid, IconButton,
} from '@material-ui/core';

import DeleteIcon from '@material-ui/icons/DeleteForever';
import AddIcon from '@material-ui/icons/AddCircle';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Group/Outcome/messages';
import { buildValues } from 'utils/formHelpers';

const styles = theme => ({
  addItemButtonIcon: {
    fontSize: 35,
  },
  removableItem: {
    position: 'relative',
  },
  itemRemoveButton: {
    color: theme.palette.error.main,
    position: 'absolute',
    right: 3,
    top: 3,
    zIndex: 1,
  },
});

const INITIAL_PILLAR = {
  name: '',
  value_proposition: '',
};

/* eslint-disable object-curly-newline */
export function OutcomeFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, classes, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='name'
            name='name'
            label={<FormattedMessage {...messages.inputs.name} />}
            value={values.name}
          />
        </CardContent>
        <Divider />
        <CardContent>
          <FieldArray
            name='pillars_attributes'
            render={arrayHelpers => (
              <React.Fragment>
                <Grid container alignItems='center'>
                  <Grid item xs>
                    <Typography
                      variant='h6'
                    >
                      Pillars
                    </Typography>
                  </Grid>
                  <Grid item>
                    <IconButton
                      color='primary'
                      onClick={() => arrayHelpers.push(INITIAL_PILLAR)}
                    >
                      <AddIcon className={classes.addItemButtonIcon} />
                    </IconButton>
                  </Grid>
                </Grid>
                <Box mb={1} />
                {props.outcome && values.pillars_attributes && values.pillars_attributes.length > 0 && values.pillars_attributes.map((pillar, i) => {
                  /* eslint-disable-next-line react/no-array-index-key  */
                  if (Object.hasOwnProperty.call(pillar, '_destroy')) return (<React.Fragment key={pillar.id} />);

                  return (
                    <React.Fragment key={pillar.id || `new_${i}`}>
                      {i > 0 && (<Box mb={3} />)}
                      <Paper
                        className={classes.removableItem}
                        elevation={2}
                        square
                      >
                        <IconButton
                          className={classes.itemRemoveButton}
                          onClick={() => {
                            if (values.pillars_attributes[i].id)
                              setFieldValue(`pillars_attributes.${i}._destroy`, '1');
                            else
                              arrayHelpers.remove(i);
                          }}
                        >
                          <DeleteIcon />
                        </IconButton>
                        <CardContent>
                          <Field
                            component={TextField}
                            onChange={handleChange}
                            fullWidth
                            id={`pillars_attributes.${i}.name`}
                            name={`pillars_attributes.${i}.name`}
                            label={<FormattedMessage {...messages.pillars.inputs.name} />}
                            value={values.pillars_attributes[i].name}
                          />
                          <Field
                            component={TextField}
                            onChange={handleChange}
                            fullWidth
                            id={`pillars_attributes.${i}.value_proposition`}
                            name={`pillars_attributes.${i}.value_proposition`}
                            label={<FormattedMessage {...messages.pillars.inputs.value} />}
                            value={values.pillars_attributes[i].value_proposition || ''}
                          />
                        </CardContent>
                      </Paper>
                    </React.Fragment>
                  );
                })}
                {props.outcome && (!values.pillars_attributes || values.pillars_attributes.length <= 0) && (
                  <Typography color='textSecondary'>
                    <FormattedMessage {...messages.empty} />
                  </Typography>
                )}
              </React.Fragment>
            )}
          />
        </CardContent>
        <Divider />
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            {buttonText}
          </Button>
          <Button
            to={props.links.outcomesIndex}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function OutcomeForm(props) {
  const outcome = dig(props, 'outcome');

  const initialValues = buildValues(outcome, {
    id: { default: '' },
    name: { default: '' },
    group_id: { default: dig(props, 'currentGroup', 'id') || '' },
    pillars: { default: [], customKey: 'pillars_attributes' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, _) => {
        props.outcomeAction(values);
      }}

      render={formikProps => <OutcomeFormInner {...props} {...formikProps} />}
    />
  );
}

OutcomeForm.propTypes = {
  outcomeAction: PropTypes.func,
  outcome: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object
};

OutcomeFormInner.propTypes = {
  classes: PropTypes.object,
  outcome: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    outcomesIndex: PropTypes.string,
  })
};

export default compose(
  withStyles(styles),
  memo,
)(OutcomeForm);
