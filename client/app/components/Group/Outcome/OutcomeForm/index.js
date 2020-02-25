/**
 *
 * Outcome Form Component
 *
 */

import React, { memo, useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/Outcome/messages';
import { Field, Formik, Form, FieldArray } from 'formik';
import {
  withStyles, Button, Card, CardActions, CardContent, TextField, Divider, Typography, Paper, Box, Grid, IconButton, Collapse
} from '@material-ui/core';

import DeleteIcon from '@material-ui/icons/DeleteForever';
import AddIcon from '@material-ui/icons/AddCircle';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { buildValues, isAttributesArrayEmpty } from 'utils/formHelpers';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

import { CONTENT_SCROLL_CLASS_NAME } from 'components/Shared/Scrollbar';
import animateScrollTo from 'animated-scroll-to';

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

/* eslint-disable no-underscore-dangle */
/* eslint-disable object-curly-newline */
export function OutcomeFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, classes, ...props }) {
  const pillarsAttributes = values.pillars_attributes;

  useEffect(() => {
    if (!isAttributesArrayEmpty(pillarsAttributes) && pillarsAttributes[pillarsAttributes.length - 1]._initialized === true)
      animateScrollTo(document.querySelector('.last-field-array-item'), {
        elementToScroll: document.querySelector(`.${CONTENT_SCROLL_CLASS_NAME}`)
      });
  });

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.outcome}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              id='name'
              name='name'
              label={<DiverstFormattedMessage {...messages.inputs.name} />}
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
                        <DiverstFormattedMessage {...messages.pillars.title} />
                      </Typography>
                    </Grid>
                    <Grid item>
                      <IconButton
                        color='primary'
                        onClick={() => {
                          arrayHelpers.push({
                            ...INITIAL_PILLAR,
                            _localKey: `new_${pillarsAttributes.length}`,
                            _initialized: false,
                          });
                        }}
                      >
                        <AddIcon className={classes.addItemButtonIcon} />
                      </IconButton>
                    </Grid>
                  </Grid>
                  <Box mb={1} />
                  {pillarsAttributes && pillarsAttributes.length > 0 && pillarsAttributes.map((pillar, i) => {
                    /* eslint-disable-next-line react/no-array-index-key  */
                    if (Object.hasOwnProperty.call(pillar, '_destroy')) return (<React.Fragment key={pillar.id} />);

                    return (
                      <div key={pillar.id || pillar._localKey}>
                        <Collapse
                          in={!pillar._hidden}
                          appear={pillar._hidden || !pillar._initialized}
                          onExited={() => {
                            if (pillar.id)
                              setFieldValue(`pillars_attributes.${i}._destroy`, '1');
                            else
                              arrayHelpers.remove(i);
                          }}
                          onEntered={(_, isAppearing) => {
                            if (isAppearing && pillar._initialized === false)
                              setFieldValue(`pillars_attributes.${i}._initialized`, true);
                          }}
                        >
                          <Paper
                            className={classes.removableItem}
                            elevation={2}
                            square
                          >
                            <IconButton
                              className={classes.itemRemoveButton}
                              onClick={() => setFieldValue(`pillars_attributes.${i}._hidden`, true)}
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
                                margin='normal'
                                label={<DiverstFormattedMessage {...messages.pillars.inputs.name} />}
                                value={pillarsAttributes[i].name}
                              />
                              <Field
                                component={TextField}
                                onChange={handleChange}
                                fullWidth
                                id={`pillars_attributes.${i}.value_proposition`}
                                name={`pillars_attributes.${i}.value_proposition`}
                                margin='normal'
                                label={<DiverstFormattedMessage {...messages.pillars.inputs.value} />}
                                value={pillarsAttributes[i].value_proposition || ''}
                              />
                            </CardContent>
                          </Paper>
                          <Box
                            mb={3}
                            className={i === pillarsAttributes.length - 1 ? 'last-field-array-item' : undefined}
                          />
                        </Collapse>
                      </div>
                    );
                  })}
                  {isAttributesArrayEmpty(pillarsAttributes) && (
                    <Collapse in appear>
                      <Typography color='textSecondary'>
                        <DiverstFormattedMessage {...messages.pillars.empty} />
                      </Typography>
                    </Collapse>
                  )}
                </React.Fragment>
              )}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              to={props.links.outcomesIndex}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
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
    >
      {formikProps => <OutcomeFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

OutcomeForm.propTypes = {
  edit: PropTypes.bool,
  outcomeAction: PropTypes.func,
  outcome: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

OutcomeFormInner.propTypes = {
  edit: PropTypes.bool,
  classes: PropTypes.object,
  outcome: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    outcomesIndex: PropTypes.string,
  })
};

export default compose(
  withStyles(styles),
  memo,
)(OutcomeForm);
